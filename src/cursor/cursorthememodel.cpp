/*
 * Copyright (C) 2021 CutefishOS Team.
 * GPL v3 or later
 */

#include "cursorthememodel.h"
#include "cursortheme.h"
#include <QDBusConnection>
#include <QDBusInterface>
#include <QDBusPendingCall>
#include <QFileInfo>
#include <QDebug>
#include <QDir>
#include <QGuiApplication>

// Qt6: QX11Info 已删除，XFixes 相关调用由 cursortheme.cpp 中的 haveXfixes() 保护
// Wayland 下 haveXfixes() 返回 false，以下 include 在 Wayland 下不会实际执行
#include <X11/Xcursor/Xcursor.h>
#include <X11/extensions/Xfixes.h>

// 获取 X11 display（仅 xcb 平台）
static Display *x11Display()
{
    auto *ni = qGuiApp->nativeInterface<QNativeInterface::QX11Application>();
    return ni ? ni->display() : nullptr;
}

CursorThemeModel::CursorThemeModel(QObject *parent)
    : QAbstractListModel(parent)
    , m_settings("cutefishos", "theme")
{
    initThemes();
    m_currentTheme = m_settings.value("CursorTheme", "default").toString();
}

CursorThemeModel::~CursorThemeModel()
{
    qDeleteAll(m_list);
    m_list.clear();
}

QHash<int, QByteArray> CursorThemeModel::roleNames() const
{
    QHash<int, QByteArray> roleNames = QAbstractListModel::roleNames();
    roleNames[CursorThemeModel::NameRole]  = "name";
    roleNames[CursorThemeModel::ImageRole] = "image";
    roleNames[CursorThemeModel::PathRole]  = "path";
    roleNames[CursorThemeModel::IdRole]    = "id";
    return roleNames;
}

int CursorThemeModel::rowCount(const QModelIndex &) const
{
    return m_list.size();
}

QVariant CursorThemeModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_list.size())
        return QVariant();

    CursorTheme *theme = m_list.at(index.row());

    switch (role) {
    case CursorThemeModel::NameRole:  return theme->name();
    case CursorThemeModel::ImageRole: return theme->path();
    case CursorThemeModel::PathRole:  return theme->path();
    case CursorThemeModel::IdRole:    return theme->id();
    default: break;
    }
    return QVariant();
}

QString CursorThemeModel::currentTheme() const { return m_currentTheme; }

void CursorThemeModel::setCurrentTheme(const QString &theme)
{
    if (m_currentTheme != theme) {
        m_currentTheme = theme;
        emit currentThemeChanged();

        QDBusInterface interface("com.cutefish.Settings",
                                 "/Theme",
                                 "com.cutefish.Theme",
                                 QDBusConnection::sessionBus());
        if (interface.isValid())
            interface.asyncCall("setCursorTheme", m_currentTheme);

        int index = themeIndex(m_currentTheme);
        CursorTheme *curTheme = nullptr;
        if (index >= 0 && index < m_list.size())
            curTheme = m_list.at(index);

        // haveXfixes() 在 Wayland 下返回 false，此块不会执行
        if (curTheme && CursorTheme::haveXfixes()) {
            Display *dpy = x11Display();
            if (!dpy) return;

            QStringList names;
            names << "left_ptr" << "up_arrow" << "cross" << "wait" << "left_ptr_watch"
                  << "ibeam" << "size_ver" << "size_hor" << "size_bdiag" << "size_fdiag"
                  << "size_all" << "split_v" << "split_h" << "pointing_hand" << "openhand"
                  << "closedhand" << "forbidden" << "whats_this" << "copy" << "move" << "link"
                  << "X_cursor" << "right_ptr" << "hand1" << "hand2" << "watch" << "xterm"
                  << "crosshair" << "left_ptr_watch" << "center_ptr" << "sb_h_double_arrow"
                  << "sb_v_double_arrow" << "fleur" << "top_left_corner" << "top_side"
                  << "top_right_corner" << "right_side" << "bottom_right_corner" << "bottom_side"
                  << "bottom_left_corner" << "left_side" << "question_arrow" << "pirate";

            int cursorSize = m_settings.value("CursorSize").toInt()
                           * m_settings.value("PixelRatio").toReal();

            for (const QString &name : names) {
                XFixesChangeCursorByName(dpy,
                                         curTheme->loadCursor(name, cursorSize),
                                         QFile::encodeName(name));
            }
        }
    }
}

int CursorThemeModel::themeIndex(const QString &theme)
{
    QString id = theme;
    if (id == "default")
        id = m_defaultTheme;

    for (int i = 0; i < m_list.size(); ++i) {
        if (m_list.at(i)->id() == id)
            return i;
    }
    return -1;
}

void CursorThemeModel::initThemes()
{
    for (const QString &baseDir : paths()) {
        QDir dir(baseDir);
        if (!dir.exists())
            continue;
        for (const QString &name : dir.entryList(QDir::Dirs | QDir::NoDotAndDotDot)) {
            if (!dir.cd(name))
                continue;
            processDir(dir);
            dir.cdUp();
        }
    }
}

QStringList CursorThemeModel::paths()
{
    QStringList list;
    list << QDir::home().path() + ".icons";
    list << "/usr/share/icons";
    list << "/usr/share/pixmaps";
    return list;
}

void CursorThemeModel::processDir(const QDir &dir)
{
    if (m_defaultTheme.isNull() && dir.dirName() == "default") {
        QFileInfo info(dir.path());
        if (info.isSymLink()) {
            QFileInfo target(info.symLinkTarget());
            if (target.exists() && (target.isDir() || target.isSymLink()))
                m_defaultTheme = target.fileName();
            return;
        }
        if (!dir.exists("cursors") ||
            QDir(dir.path() + "/cursor").entryList(QDir::Files | QDir::NoDotAndDotDot).isEmpty()) {
            if (dir.exists("index.theme")) {
                CursorTheme theme(dir);
                m_defaultTheme = theme.inherits();
                return;
            }
        }
    }

    if (!dir.exists("cursors"))
        return;
    if (!dir.exists("index.theme") && !dir.exists("cursor.theme"))
        return;

    CursorTheme *theme = new CursorTheme(dir);
    for (int i = 0; i < m_list.size(); ++i) {
        if (m_list.at(i)->name() == theme->name()) {
            delete theme;
            return;
        }
    }

    beginInsertRows(QModelIndex(), m_list.size(), m_list.size());
    m_list.append(theme);
    endInsertRows();
}

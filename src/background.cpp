#include "background.h"
#include <QtConcurrent>

static QVariantList getBackgroundPaths()
{
    QVariantList list;
    QDirIterator it("/usr/share/backgrounds/cutefishos",
                    QStringList() << "*.jpg" << "*.png",
                    QDir::Files,
                    QDirIterator::Subdirectories);
    while (it.hasNext()) {
        list.append(QVariant(it.next()));
    }
    // Qt6: QVariant 没有 operator<，改用 lambda 比较 toString()
    std::sort(list.begin(), list.end(), [](const QVariant &a, const QVariant &b) {
        return a.toString() < b.toString();
    });
    return list;
}

Background::Background(QObject *parent)
    : QObject(parent)
    , m_interface("com.cutefish.Settings",
                  "/Theme",
                  "com.cutefish.Theme",
                  QDBusConnection::sessionBus(), this)
{
    if (m_interface.isValid()) {
        m_currentPath = m_interface.property("wallpaper").toString();
        QDBusConnection::sessionBus().connect(m_interface.service(),
                                              m_interface.path(),
                                              m_interface.interface(),
                                              "backgroundTypeChanged", this, SIGNAL(backgroundTypeChanged()));
        QDBusConnection::sessionBus().connect(m_interface.service(),
                                              m_interface.path(),
                                              m_interface.interface(),
                                              "backgroundColorChanged", this, SIGNAL(backgroundColorChanged()));
    }
}

QVariantList Background::backgrounds()
{
    QFuture<QVariantList> future = QtConcurrent::run(&getBackgroundPaths);
    return future.result();
}

QString Background::currentBackgroundPath()
{
    return m_currentPath;
}

void Background::setBackground(QString path)
{
    if (m_currentPath != path && !path.isEmpty()) {
        m_currentPath = path;
        if (m_interface.isValid()) {
            m_interface.call("setWallpaper", path);
            emit backgroundChanged();
        }
    }
}

int Background::backgroundType()
{
    return m_interface.property("backgroundType").toInt();
}

void Background::setBackgroundType(int type)
{
    m_interface.call("setBackgroundType", QVariant::fromValue(type));
}

QString Background::backgroundColor()
{
    return m_interface.property("backgroundColor").toString();
}

void Background::setBackgroundColor(const QString &color)
{
    m_interface.call("setBackgroundColor", QVariant::fromValue(color));
}

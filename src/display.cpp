/*
 * Wayland/Qt6 port: Screen Display Manager
 * Uses kscreen-doctor for resolution/rotation control
 */

#include "display.h"
#include <QDebug>
#include <QRegularExpression>

DisplayManager::DisplayManager(QObject *parent)
    : QObject(parent)
{
    refresh();
}

QString DisplayManager::outputName() const { return m_outputName; }
QStringList DisplayManager::resolutions() const { return m_resolutions; }
int DisplayManager::currentResolutionIndex() const { return m_currentResolutionIndex; }
int DisplayManager::currentRotationIndex() const { return m_currentRotationIndex; }
bool DisplayManager::loading() const { return m_loading; }

QStringList DisplayManager::rotations() const
{
    return {tr("Normal"), tr("Left 90°"), tr("Inverted"), tr("Right 90°")};
}

void DisplayManager::refresh()
{
    m_loading = true;
    emit loadingChanged();

    QProcess *proc = new QProcess(this);
    connect(proc, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, [this, proc](int exitCode, QProcess::ExitStatus) {
        if (exitCode == 0) {
            parseOutput(proc->readAllStandardOutput());
        } else {
            qWarning() << "kscreen-doctor failed:" << proc->readAllStandardError();
        }
        proc->deleteLater();
        m_loading = false;
        emit loadingChanged();
    });

    proc->start("kscreen-doctor", {"-o"});
}

void DisplayManager::parseOutput(const QString &output)
{
    m_resolutions.clear();
    m_modeIds.clear();
    m_currentResolutionIndex = 0;
    m_currentRotationIndex = 0;
    m_outputName.clear();

    // 解析第一个 Output 块
    // 格式：Output: 1 eDP-1 ...
    QRegularExpression outputNameRe(R"(Output:\s+\d+\s+(\S+))");
    auto m = outputNameRe.match(output);
    if (m.hasMatch())
        m_outputName = m.captured(1);

    // 解析 Rotation: N
    QRegularExpression rotRe(R"(Rotation:\s+(\d+))");
    auto rm = rotRe.match(output);
    if (rm.hasMatch()) {
        int rotVal = rm.captured(1).toInt();
        m_currentRotationIndex = m_rotationValues.indexOf(rotVal);
        if (m_currentRotationIndex < 0)
            m_currentRotationIndex = 0;
    }

    // 解析 Modes 块
    // 格式：  1:3000x2000@60.00*!  2:3000x2000@48.01 ...
    // * 表示当前模式，! 表示首选模式
    QRegularExpression modeRe(R"((\d+):(\d+x\d+)@([\d.]+)([*!]*))", QRegularExpression::MultilineOption);
    QRegularExpressionMatchIterator it = modeRe.globalMatch(output);

    // 用来去重（同分辨率只保留最高刷新率）
    QMap<QString, QPair<QString, double>> bestModes; // res -> (id, hz)

    while (it.hasNext()) {
        auto mm = it.next();
        QString id   = mm.captured(1);
        QString res  = mm.captured(2);
        double  hz   = mm.captured(3).toDouble();
        QString flags = mm.captured(4);

        bool isCurrent = flags.contains('*');

        // 同分辨率保留最高刷新率
        if (!bestModes.contains(res) || hz > bestModes[res].second) {
            bestModes[res] = {id, hz};
        }

        if (isCurrent) {
            // 先记录当前分辨率，后面找索引
            m_outputName = m_outputName; // 保持
            // 找当前模式对应的 res
            // 等 bestModes 填完再找索引
            Q_UNUSED(isCurrent);
        }
    }

    // 重新跑一遍找当前模式的分辨率
    QString currentRes;
    {
        QRegularExpressionMatchIterator it2 = modeRe.globalMatch(output);
        while (it2.hasNext()) {
            auto mm = it2.next();
            if (mm.captured(4).contains('*')) {
                currentRes = mm.captured(2);
                break;
            }
        }
    }

    // 把 bestModes 转成列表（按分辨率像素数降序）
    QList<QPair<QString,QString>> modeList; // (res, id)
    for (auto it3 = bestModes.begin(); it3 != bestModes.end(); ++it3) {
        modeList.append({it3.key(), it3.value().first});
    }

    // 按像素数降序排列
    std::sort(modeList.begin(), modeList.end(), [](const QPair<QString,QString> &a, const QPair<QString,QString> &b) {
        auto parsePixels = [](const QString &res) -> int {
            auto parts = res.split('x');
            if (parts.size() == 2)
                return parts[0].toInt() * parts[1].toInt();
            return 0;
        };
        return parsePixels(a.first) > parsePixels(b.first);
    });

    for (int i = 0; i < modeList.size(); ++i) {
        m_resolutions.append(modeList[i].first);
        m_modeIds.append(modeList[i].second);
        if (modeList[i].first == currentRes)
            m_currentResolutionIndex = i;
    }

    emit outputInfoChanged();
}

void DisplayManager::setResolution(int index)
{
    if (index < 0 || index >= m_modeIds.size())
        return;

    QString arg = QString("output.%1.mode.%2").arg(m_outputName, m_modeIds[index]);
    runDoctor({arg});
}

void DisplayManager::setRotation(int index)
{
    if (index < 0 || index >= m_rotationValues.size())
        return;

    QString arg = QString("output.%1.rotation.%2").arg(m_outputName).arg(m_rotationValues[index]);
    runDoctor({arg});
}

void DisplayManager::runDoctor(const QStringList &args)
{
    QProcess *proc = new QProcess(this);
    connect(proc, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, [this, proc](int exitCode, QProcess::ExitStatus) {
        if (exitCode != 0)
            qWarning() << "kscreen-doctor error:" << proc->readAllStandardError();
        proc->deleteLater();
        // 应用后刷新状态
        refresh();
    });
    proc->start("kscreen-doctor", args);
}

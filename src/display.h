/*
 * Wayland/Qt6 port: Screen Display Manager
 * Uses kscreen-doctor for resolution/rotation control
 */

#pragma once

#include <QObject>
#include <QStringList>
#include <QProcess>

class DisplayManager : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString outputName READ outputName NOTIFY outputInfoChanged)
    Q_PROPERTY(QStringList resolutions READ resolutions NOTIFY outputInfoChanged)
    Q_PROPERTY(int currentResolutionIndex READ currentResolutionIndex NOTIFY outputInfoChanged)
    Q_PROPERTY(QStringList rotations READ rotations CONSTANT)
    Q_PROPERTY(int currentRotationIndex READ currentRotationIndex NOTIFY outputInfoChanged)
    Q_PROPERTY(bool loading READ loading NOTIFY loadingChanged)

public:
    explicit DisplayManager(QObject *parent = nullptr);

    QString outputName() const;
    QStringList resolutions() const;
    int currentResolutionIndex() const;
    QStringList rotations() const;
    int currentRotationIndex() const;
    bool loading() const;

    Q_INVOKABLE void refresh();
    Q_INVOKABLE void setResolution(int index);
    Q_INVOKABLE void setRotation(int index);

signals:
    void outputInfoChanged();
    void loadingChanged();

private:
    void parseOutput(const QString &output);
    void runDoctor(const QStringList &args);

    QString m_outputName;
    QStringList m_resolutions;
    QStringList m_modeIds;
    int m_currentResolutionIndex = 0;
    int m_currentRotationIndex = 0;
    bool m_loading = false;

    // kscreen-doctor rotation 值: 1=normal 2=left 4=inverted 8=right
    const QList<int> m_rotationValues = {1, 2, 4, 8};
};

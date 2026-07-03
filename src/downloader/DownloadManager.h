#ifndef DOWNLOADMANAGER_H
#define DOWNLOADMANAGER_H

#include <QObject>
#include <QProcess>
#include <QHash>

class DownloadManager : public QObject
{
    Q_OBJECT
public:
    explicit DownloadManager(QObject *parent = nullptr);

    Q_INVOKABLE void startDownload(const QString& videoId, bool isAudioOnly, const QString& destinationFolder);
    Q_INVOKABLE void cancelDownload(const QString& videoId);

signals:
    void progressUpdated(const QString& videoId, int percentage);
    void downloadCompleted(const QString& videoId, const QString& filePath);
    void downloadFailed(const QString& videoId, const QString& error);

private slots:
    void onProcessReadyReadStandardOutput(const QString& videoId);
    void onProcessFinished(const QString& videoId, int exitCode, QProcess::ExitStatus exitStatus);

private:
    QHash<QString, QProcess*> m_processes;
};

#endif // DOWNLOADMANAGER_H

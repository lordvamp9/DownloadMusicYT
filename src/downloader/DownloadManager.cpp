#include "DownloadManager.h"
#include <QDir>
#include <QRegularExpression>
#include <QDebug>

DownloadManager::DownloadManager(QObject *parent) : QObject(parent)
{
}

void DownloadManager::startDownload(const QString& videoId, bool isAudioOnly, const QString& destinationFolder)
{
    if (m_processes.contains(videoId)) {
        return; // Already downloading
    }

    QProcess* process = new QProcess(this);
    m_processes.insert(videoId, process);

    QString program = "yt-dlp.exe";
    QStringList arguments;
    
    // Configuración base de yt-dlp
    arguments << "--newline"; // Para facilitar el parseo del progreso por línea
    arguments << "-o" << destinationFolder + "/%(title)s.%(ext)s";
    
    if (isAudioOnly) {
        arguments << "-x" << "--audio-format" << "mp3" << "--audio-quality" << "192K";
    } else {
        arguments << "-f" << "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best";
    }

    arguments << "https://www.youtube.com/watch?v=" + videoId;

    connect(process, &QProcess::readyReadStandardOutput, this, [this, videoId]() {
        onProcessReadyReadStandardOutput(videoId);
    });

    connect(process, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished),
            this, [this, videoId](int exitCode, QProcess::ExitStatus exitStatus) {
        onProcessFinished(videoId, exitCode, exitStatus);
    });

    process->start(program, arguments);
}

void DownloadManager::cancelDownload(const QString& videoId)
{
    if (m_processes.contains(videoId)) {
        QProcess* process = m_processes.value(videoId);
        process->kill();
        process->waitForFinished(1000);
        m_processes.remove(videoId);
        emit downloadFailed(videoId, "Canceled by user");
        process->deleteLater();
    }
}

void DownloadManager::onProcessReadyReadStandardOutput(const QString& videoId)
{
    QProcess* process = qobject_cast<QProcess*>(sender());
    if (!process) return;

    while (process->canReadLine()) {
        QString line = QString::fromLocal8Bit(process->readLine()).trimmed();
        
        // yt-dlp outputs something like: [download]  12.3% of 4.56MiB at  1.23MiB/s ETA 00:03
        QRegularExpression re("\\[download\\]\\s+(\\d+\\.\\d+)%");
        QRegularExpressionMatch match = re.match(line);
        if (match.hasMatch()) {
            double percent = match.captured(1).toDouble();
            emit progressUpdated(videoId, static_cast<int>(percent));
        }
    }
}

void DownloadManager::onProcessFinished(const QString& videoId, int exitCode, QProcess::ExitStatus exitStatus)
{
    QProcess* process = m_processes.value(videoId, nullptr);
    if (process) {
        if (exitStatus == QProcess::NormalExit && exitCode == 0) {
            emit downloadCompleted(videoId, "path/to/file.mp3"); // En un caso real parsearíamos el path exacto de stdout
        } else {
            emit downloadFailed(videoId, "Download failed or process crashed.");
        }
        m_processes.remove(videoId);
        process->deleteLater();
    }
}

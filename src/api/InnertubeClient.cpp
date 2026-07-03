#include "InnertubeClient.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QVariantMap>
#include <QDebug>

InnertubeClient::InnertubeClient(QObject *parent) : QObject(parent), m_process(nullptr)
{
}

void InnertubeClient::search(const QString& query)
{
    if (m_process) {
        m_process->kill();
        m_process->deleteLater();
    }

    m_process = new QProcess(this);
    
    // Using yt-dlp to search youtube and return JSON output
    QString program = "yt-dlp.exe";
    QStringList arguments;
    arguments << ("ytsearch10:" + query) << "-J" << "--flat-playlist";

    connect(m_process, QOverload<int, QProcess::ExitStatus>::of(&QProcess::finished), this, [this](int exitCode, QProcess::ExitStatus exitStatus) {
        if (exitStatus != QProcess::NormalExit || exitCode != 0) {
            emit errorOccurred("Failed to search. Check if yt-dlp.exe is working.");
            m_process->deleteLater();
            m_process = nullptr;
            return;
        }

        QByteArray data = m_process->readAllStandardOutput();
        QJsonDocument doc = QJsonDocument::fromJson(data);
        if (!doc.isObject()) {
            emit errorOccurred("Invalid search data returned.");
            m_process->deleteLater();
            m_process = nullptr;
            return;
        }

        QVariantList parsedResults;
        QJsonArray entries = doc.object().value("entries").toArray();
        for (int i = 0; i < entries.size(); ++i) {
            QJsonObject entry = entries[i].toObject();
            QVariantMap result;
            result["videoId"] = entry.value("id").toString();
            result["title"] = entry.value("title").toString();
            result["author"] = entry.value("uploader").toString();
            
            // Generate a high quality thumbnail url
            QString thumb = "https://i.ytimg.com/vi/" + entry.value("id").toString() + "/hqdefault.jpg";
            result["thumbnail"] = thumb;
            
            // Format duration
            int durationSecs = entry.value("duration").toInt();
            int mins = durationSecs / 60;
            int secs = durationSecs % 60;
            result["duration"] = QString("%1:%2").arg(mins).arg(secs, 2, 10, QChar('0'));
            
            parsedResults.append(result);
        }

        emit searchCompleted(parsedResults);
        m_process->deleteLater();
        m_process = nullptr;
    });

    m_process->start(program, arguments);
}

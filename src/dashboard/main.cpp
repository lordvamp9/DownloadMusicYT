#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "../api/InnertubeClient.h"
#include <QFile>
#include <QTextStream>
#include <QQmlError>
#include "../downloader/DownloadManager.h"
#include "../models/DownloadQueueModel.h"
#include "../player/NativeAudioPlayer.h"
#include <QIcon>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setWindowIcon(QIcon(":/ui/icons/download.ico"));

    QQmlApplicationEngine engine;

    // Registrar clases C++ para ser usadas en QML
    qmlRegisterType<InnertubeClient>("com.vamp9.ytmusic", 1, 0, "InnertubeClient");
    qmlRegisterType<DownloadManager>("com.vamp9.ytmusic", 1, 0, "DownloadManager");
    qmlRegisterType<DownloadQueueModel>("com.vamp9.ytmusic", 1, 0, "DownloadQueueModel");
    qmlRegisterType<NativeAudioPlayer>("com.vamp9.ytmusic", 1, 0, "NativeAudioPlayer");

    QObject::connect(&engine, &QQmlApplicationEngine::warnings, [](const QList<QQmlError> &warnings){
        QFile file("qml_errors.txt");
        if (file.open(QIODevice::WriteOnly | QIODevice::Append | QIODevice::Text)) {
            QTextStream out(&file);
            for (const auto &w : warnings) {
                out << w.toString() << "\n";
            }
        }
    });

    const QUrl url(u"qrc:/ui/main.qml"_qs);
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}

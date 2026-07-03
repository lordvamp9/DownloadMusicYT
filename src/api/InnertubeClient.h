#ifndef INNERTUBECLIENT_H
#define INNERTUBECLIENT_H

#include <QObject>
#include <QProcess>
#include <QVariantList>

class InnertubeClient : public QObject
{
    Q_OBJECT
public:
    explicit InnertubeClient(QObject *parent = nullptr);

    Q_INVOKABLE void search(const QString& query);

signals:
    void searchCompleted(const QVariantList& results);
    void errorOccurred(const QString& errorString);

private:
    QProcess* m_process;
};

#endif // INNERTUBECLIENT_H

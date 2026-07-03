#ifndef DOWNLOADQUEUEMODEL_H
#define DOWNLOADQUEUEMODEL_H

#include <QAbstractListModel>
#include <QList>

struct DownloadItem {
    QString videoId;
    QString title;
    QString thumbnail;
    int progress;
    QString status; // "Downloading", "Completed", "Error", "Canceled"
};

class DownloadQueueModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum Roles {
        VideoIdRole = Qt::UserRole + 1,
        TitleRole,
        ThumbnailRole,
        ProgressRole,
        StatusRole
    };

    explicit DownloadQueueModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void addDownload(const QString& videoId, const QString& title, const QString& thumbnail);
    Q_INVOKABLE void updateProgress(const QString& videoId, int progress);
    Q_INVOKABLE void updateStatus(const QString& videoId, const QString& status);
    Q_INVOKABLE void removeDownload(const QString& videoId);

private:
    QList<DownloadItem> m_items;
    int findItemIndex(const QString& videoId) const;
};

#endif // DOWNLOADQUEUEMODEL_H

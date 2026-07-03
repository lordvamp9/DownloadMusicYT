#include "DownloadQueueModel.h"

DownloadQueueModel::DownloadQueueModel(QObject *parent)
    : QAbstractListModel(parent)
{
}

int DownloadQueueModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_items.count();
}

QVariant DownloadQueueModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() >= m_items.count())
        return QVariant();

    const DownloadItem &item = m_items[index.row()];
    switch (role) {
    case VideoIdRole: return item.videoId;
    case TitleRole: return item.title;
    case ThumbnailRole: return item.thumbnail;
    case ProgressRole: return item.progress;
    case StatusRole: return item.status;
    default: return QVariant();
    }
}

QHash<int, QByteArray> DownloadQueueModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[VideoIdRole] = "videoId";
    roles[TitleRole] = "title";
    roles[ThumbnailRole] = "thumbnail";
    roles[ProgressRole] = "progress";
    roles[StatusRole] = "status";
    return roles;
}

void DownloadQueueModel::addDownload(const QString& videoId, const QString& title, const QString& thumbnail)
{
    if (findItemIndex(videoId) != -1) return; // Already exists

    beginInsertRows(QModelIndex(), m_items.count(), m_items.count());
    m_items.append({videoId, title, thumbnail, 0, "Downloading"});
    endInsertRows();
}

void DownloadQueueModel::updateProgress(const QString& videoId, int progress)
{
    int index = findItemIndex(videoId);
    if (index != -1) {
        m_items[index].progress = progress;
        QModelIndex modelIndex = createIndex(index, 0);
        emit dataChanged(modelIndex, modelIndex, {ProgressRole});
    }
}

void DownloadQueueModel::updateStatus(const QString& videoId, const QString& status)
{
    int index = findItemIndex(videoId);
    if (index != -1) {
        m_items[index].status = status;
        QModelIndex modelIndex = createIndex(index, 0);
        emit dataChanged(modelIndex, modelIndex, {StatusRole});
    }
}

void DownloadQueueModel::removeDownload(const QString& videoId)
{
    int index = findItemIndex(videoId);
    if (index != -1) {
        beginRemoveRows(QModelIndex(), index, index);
        m_items.removeAt(index);
        endRemoveRows();
    }
}

int DownloadQueueModel::findItemIndex(const QString& videoId) const
{
    for (int i = 0; i < m_items.count(); ++i) {
        if (m_items[i].videoId == videoId)
            return i;
    }
    return -1;
}

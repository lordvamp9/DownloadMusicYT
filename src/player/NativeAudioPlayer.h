#ifndef NATIVEAUDIOPLAYER_H
#define NATIVEAUDIOPLAYER_H

#include <QObject>
#include <QString>
#include <QTimer>

class NativeAudioPlayer : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int duration READ duration NOTIFY durationChanged)
    Q_PROPERTY(int position READ position WRITE setPosition NOTIFY positionChanged)
    Q_PROPERTY(bool isPlaying READ isPlaying NOTIFY isPlayingChanged)
    
public:
    explicit NativeAudioPlayer(QObject *parent = nullptr);
    ~NativeAudioPlayer();

    Q_INVOKABLE void setSource(const QString& filePath);
    Q_INVOKABLE void play();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void setVolume(double vol);

    int duration() const;
    int position() const;
    void setPosition(int pos);
    bool isPlaying() const;

signals:
    void durationChanged();
    void positionChanged();
    void isPlayingChanged();

private:
    void updatePosition();
    void releaseDirectShow();
    
    int m_duration = 0;
    int m_position = 0;
    bool m_isPlaying = false;
    QTimer m_timer;
    
    void* m_pGraph = nullptr;
    void* m_pControl = nullptr;
    void* m_pSeeking = nullptr;
    void* m_pAudio = nullptr;
};

#endif

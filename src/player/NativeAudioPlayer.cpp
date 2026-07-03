#include "NativeAudioPlayer.h"
#include <windows.h>
#include <dshow.h>
#include <QUrl>

#pragma comment(lib, "strmiids.lib")
#pragma comment(lib, "ole32.lib")
#pragma comment(lib, "oleaut32.lib")

#define P_GRAPH ((IGraphBuilder*)m_pGraph)
#define P_CONTROL ((IMediaControl*)m_pControl)
#define P_SEEKING ((IMediaSeeking*)m_pSeeking)
#define P_AUDIO ((IBasicAudio*)m_pAudio)

NativeAudioPlayer::NativeAudioPlayer(QObject *parent) : QObject(parent)
{
    CoInitializeEx(NULL, COINIT_MULTITHREADED);
    connect(&m_timer, &QTimer::timeout, this, &NativeAudioPlayer::updatePosition);
}

void NativeAudioPlayer::releaseDirectShow()
{
    if (P_CONTROL) { P_CONTROL->Stop(); }
    if (P_AUDIO) { P_AUDIO->Release(); m_pAudio = nullptr; }
    if (P_SEEKING) { P_SEEKING->Release(); m_pSeeking = nullptr; }
    if (P_CONTROL) { P_CONTROL->Release(); m_pControl = nullptr; }
    if (P_GRAPH) { P_GRAPH->Release(); m_pGraph = nullptr; }
}

NativeAudioPlayer::~NativeAudioPlayer()
{
    stop();
    releaseDirectShow();
    CoUninitialize();
}

void NativeAudioPlayer::setSource(const QString& filePath)
{
    stop();
    releaseDirectShow();
    
    QString path = filePath;
    if(path.startsWith("file:///")) {
        path = QUrl(filePath).toLocalFile();
    }
    path.replace("/", "\\");
    
    IGraphBuilder *pGraph = nullptr;
    if (FAILED(CoCreateInstance(CLSID_FilterGraph, NULL, CLSCTX_INPROC_SERVER, IID_IGraphBuilder, (void **)&pGraph))) {
        return;
    }
    m_pGraph = pGraph;
    
    IMediaControl *pControl = nullptr;
    pGraph->QueryInterface(IID_IMediaControl, (void **)&pControl);
    m_pControl = pControl;
    
    IMediaSeeking *pSeeking = nullptr;
    pGraph->QueryInterface(IID_IMediaSeeking, (void **)&pSeeking);
    m_pSeeking = pSeeking;
    
    IBasicAudio *pAudio = nullptr;
    pGraph->QueryInterface(IID_IBasicAudio, (void **)&pAudio);
    m_pAudio = pAudio;
    
    if (SUCCEEDED(pGraph->RenderFile((LPCWSTR)path.utf16(), NULL))) {
        if (P_SEEKING) {
            P_SEEKING->SetTimeFormat(&TIME_FORMAT_MEDIA_TIME);
            LONGLONG dur = 0;
            P_SEEKING->GetDuration(&dur);
            m_duration = dur / 10000; // 100-nanoseconds to milliseconds
            emit durationChanged();
        }
    }
    
    m_position = 0;
    emit positionChanged();
}

void NativeAudioPlayer::play()
{
    if (P_CONTROL) {
        P_CONTROL->Run();
        m_isPlaying = true;
        emit isPlayingChanged();
        m_timer.start(250);
    }
}

void NativeAudioPlayer::pause()
{
    if (P_CONTROL) {
        P_CONTROL->Pause();
        m_isPlaying = false;
        emit isPlayingChanged();
        m_timer.stop();
    }
}

void NativeAudioPlayer::stop()
{
    if (P_CONTROL) {
        P_CONTROL->Stop();
        m_isPlaying = false;
        emit isPlayingChanged();
        m_timer.stop();
        
        if (P_SEEKING) {
            LONGLONG pos = 0;
            P_SEEKING->SetPositions(&pos, AM_SEEKING_AbsolutePositioning, NULL, AM_SEEKING_NoPositioning);
        }
        m_position = 0;
        emit positionChanged();
    }
}

void NativeAudioPlayer::setVolume(double vol)
{
    if (P_AUDIO) {
        // DirectShow volume is from -10000 (silence) to 0 (full volume)
        // Convert 0.0-1.0 to -10000-0
        long v = -10000;
        if (vol > 0.0) {
            // Logarithmic volume curve
            v = (long)(2000.0 * log10(vol));
            if (v > 0) v = 0;
            if (v < -10000) v = -10000;
        }
        P_AUDIO->put_Volume(v);
    }
}

int NativeAudioPlayer::duration() const { return m_duration; }
int NativeAudioPlayer::position() const { return m_position; }
bool NativeAudioPlayer::isPlaying() const { return m_isPlaying; }

void NativeAudioPlayer::setPosition(int pos)
{
    if (P_SEEKING) {
        LONGLONG dshowPos = (LONGLONG)pos * 10000;
        P_SEEKING->SetPositions(&dshowPos, AM_SEEKING_AbsolutePositioning, NULL, AM_SEEKING_NoPositioning);
        if (m_isPlaying) play();
        m_position = pos;
        emit positionChanged();
    }
}

void NativeAudioPlayer::updatePosition()
{
    if (P_SEEKING) {
        LONGLONG currentPos = 0;
        if (SUCCEEDED(P_SEEKING->GetCurrentPosition(&currentPos))) {
            m_position = currentPos / 10000;
            emit positionChanged();
            
            // Check if playback ended
            if (m_position >= m_duration && m_duration > 0) {
                stop();
            }
        }
    }
}

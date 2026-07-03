cmake_minimum_required(VERSION 3.16)
project(YouTubeMusicDownloader VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

find_package(Qt6 COMPONENTS Core Gui Qml Quick Network Sql REQUIRED)

# ==============================================================================
# Setup Executable (Intelligent Installer)
# ==============================================================================
add_executable(setup
    src/setup/main.cpp
    appicon.rc
)
target_link_libraries(setup PRIVATE Qt6::Core Qt6::Network)

# ==============================================================================
# Dashboard Executable (Main Application)
# ==============================================================================
add_executable(dashboard WIN32
    src/dashboard/main.cpp
    src/api/InnertubeClient.cpp
    src/downloader/DownloadManager.cpp
    src/models/DownloadQueueModel.cpp
    src/player/NativeAudioPlayer.cpp
    appicon.rc
    resources.qrc
)
target_link_libraries(dashboard PRIVATE Qt6::Core Qt6::Gui Qt6::Qml Qt6::Quick Qt6::Network Qt6::Sql winmm)

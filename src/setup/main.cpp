#include <QCoreApplication>
#include <QProcess>
#include <QFile>
#include <QDir>
#include <QDebug>
#include <iostream>

bool checkBinary(const QString& name) {
    // Check in current directory
    if (QFile::exists(name)) {
        return true;
    }
    // Also check PATH (optional, but good practice)
    return false; // Simplified for now, we want it portable in the same folder
}

void runPowerShell(const QString& script) {
    QProcess p;
    p.start("powershell", QStringList() << "-NoProfile" << "-ExecutionPolicy" << "Bypass" << "-Command" << script);
    p.waitForFinished(-1);
    std::cout << p.readAllStandardOutput().data();
    std::cerr << p.readAllStandardError().data();
}

int main(int argc, char *argv[]) {
    QCoreApplication app(argc, argv);
    std::cout << "===========================================" << std::endl;
    std::cout << "YouTube Music Downloader - Intelligent Setup" << std::endl;
    std::cout << "===========================================" << std::endl;

    bool needsYtDlp = !checkBinary("yt-dlp.exe");
    bool needsFfmpeg = !checkBinary("ffmpeg.exe");

    if (needsYtDlp) {
        std::cout << "[*] yt-dlp.exe is missing. Downloading from GitHub..." << std::endl;
        QString script = 
            "Invoke-WebRequest -Uri 'https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe' "
            "-OutFile 'yt-dlp.exe'";
        runPowerShell(script);
        std::cout << "[+] yt-dlp.exe downloaded successfully." << std::endl;
    } else {
        std::cout << "[+] yt-dlp.exe is already present." << std::endl;
    }

    if (needsFfmpeg) {
        std::cout << "[*] ffmpeg.exe is missing. Downloading minimal build..." << std::endl;
        QString script = 
            "$url = 'https://github.com/GyanD/codexffmpeg/releases/latest/download/ffmpeg-release-essentials.zip';"
            "$output = 'ffmpeg.zip';"
            "Invoke-WebRequest -Uri $url -OutFile $output;"
            "Expand-Archive -Path $output -DestinationPath 'ffmpeg_temp' -Force;"
            "Copy-Item -Path 'ffmpeg_temp\\*\\bin\\ffmpeg.exe' -Destination '.' -Force;"
            "Remove-Item -Path 'ffmpeg_temp' -Recurse -Force;"
            "Remove-Item -Path 'ffmpeg.zip' -Force;";
        runPowerShell(script);
        std::cout << "[+] ffmpeg.exe downloaded and extracted." << std::endl;
    } else {
        std::cout << "[+] ffmpeg.exe is already present." << std::endl;
    }

    std::cout << "\nSetup is complete! You can now launch dashboard.exe" << std::endl;
    std::cout << "Press Enter to exit..." << std::endl;
    std::cin.get();

    return 0;
}

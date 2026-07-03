# YouTube Music Downloader

Una aplicación moderna y estética para buscar y descargar música desde YouTube directamente a tu PC, construida con C++ y Qt 6.

## ✨ Características Principales
- **Descargas Rápidas (CBR MP3):** Descarga audios en alta fidelidad de 192kbps, garantizando tiempos y metadatos exactos.
- **Reproductor Nativo DirectShow:** Motor de audio propio ultra-preciso desarrollado en C++ utilizando la API nativa de Windows (DirectShow) para latencia cero.
- **Mini Reproductor Flotante:** Un reproductor musical integrado (estilo Windows Media Player) con diseño Aero Glass, soporte de carátulas y barra de progreso fluida.
- **Instalador Inteligente:** `setup.exe` se encarga de automatizar la descarga y configuración de los motores base (`yt-dlp` y `ffmpeg`) al vuelo.
- **Interfaz Fluida:** Diseñada en QML con botones asíncronos y animaciones orgánicas sin pausas ni lag.

## 🚀 Instalación y Uso (Release)

1. Descarga el archivo **`YouTubeMusicDownloader_Release.zip`** desde la sección de [Releases](../../releases).
2. Descomprime la carpeta en tu PC.
3. Ejecuta **`setup.exe`** (abrirá una consola negra). Este instalador revisará si te falta algún componente (`yt-dlp` o `ffmpeg`) y lo descargará automáticamente.
4. Cuando el setup termine, ejecuta **`dashboard.exe`**.
5. ¡Listo! Busca tu música favorita, descárgala y reprodúcela en la pestaña "Mis Descargas".

## 🛠️ Tecnologías
- **Frontend:** Qt 6 (QML / QtQuick)
- **Backend:** C++ 17
- **Audio:** Windows DirectShow API (`dshow.h`)
- **Gestión de Red:** YouTube InnerTube API
- **Motor de Descarga:** `yt-dlp` & `ffmpeg`

## 📝 Novedades en esta versión
- [Fix] Motor DirectShow implementado para lectura precisa de milisegundos en archivos de audio.
- [Fix] Altura del reproductor reparada (sin recortes en botones).
- [Fix] Botones funcionales de *Siguiente* y *Atrás* para navegar entre tus descargas.
- [Fix] `setup.exe` optimizado como aplicación de consola pura para feedback visual durante la descarga de binarios.

---
*Desarrollado para vamp9*

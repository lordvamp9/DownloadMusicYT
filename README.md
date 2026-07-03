# YouTube Music Downloader

[![C++](https://img.shields.io/badge/C%2B%2B-17-blue.svg?style=flat-square&logo=c%2B%2B)](https://en.cppreference.com/w/cpp/compiler_support/17)
[![Qt 6](https://img.shields.io/badge/Qt-6-green.svg?style=flat-square&logo=qt)](https://www.qt.io/)
[![Platform](https://img.shields.io/badge/Platform-Windows-0078D6.svg?style=flat-square&logo=windows)](https://www.microsoft.com/windows)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](LICENSE)
[![yt-dlp](https://img.shields.io/badge/Dependency-yt--dlp-red.svg?style=flat-square)](https://github.com/yt-dlp/yt-dlp)
[![FFmpeg](https://img.shields.io/badge/Dependency-FFmpeg-FE0034.svg?style=flat-square&logo=ffmpeg)](https://ffmpeg.org)

Una aplicación de escritorio moderna y estética para buscar y descargar música de YouTube directamente a tu PC, construida con C++ y Qt 6/QML.

---

##  Características Principales

*   **Descargas Rápidas (CBR MP3):** Descarga audios en alta fidelidad de 192kbps, garantizando tiempos y metadatos exactos.
*   **Reproductor Nativo DirectShow:** Motor de audio propio ultra-preciso desarrollado en C++ utilizando la API nativa de Windows (DirectShow) para latencia cero.
*   **Mini Reproductor Flotante:** Un reproductor musical integrado (estilo Windows Media Player) con diseño Aero Glass, soporte de carátulas y barra de progreso fluida.
*   **Instalador Inteligente:** `setup.exe` se encarga de automatizar la descarga y configuración de los motores base (`yt-dlp` y `ffmpeg`) al vuelo.
*   **Interfaz Fluida:** Diseñada en QML con botones asíncronos y animaciones orgánicas sin pausas ni lag.

---

##  Tecnologías

*   **Frontend:** Qt 6 (QML / QtQuick)
*   **Backend:** C++ 17
*   **Audio:** Windows DirectShow API (`dshow.h`)
*   **Gestión de Red:** YouTube InnerTube API
*   **Motores Externos:** `yt-dlp` & `ffmpeg`

---

##  Instalación y Uso (Release)

1.  Descarga el archivo **`YouTubeMusicDownloader_Release.zip`** desde la sección de [Releases](../../releases).
2.  Descomprime la carpeta en tu PC.
3.  Ejeta **`setup.exe`** (abrirá una consola). Este instalador revisará si te falta algún componente (`yt-dlp` o `ffmpeg`) y lo descargará automáticamente.
4.  Cuando el setup termine, ejecuta **`dashboard.exe`**.
5.  ¡Listo! Busca tu música favorita, descárgala y reprodúcela en la pestaña "Mis Descargas".

---

##  Licencia y Créditos de Dependencias

Este proyecto se distribuye bajo la **Licencia MIT**. Todos los derechos de copyright están reservados a nombre de [vamp9](https://github.com/lordvamp9).

Para cumplir con las políticas y evitar problemas de distribución y derechos de autor con binarios de terceros, el proyecto utiliza los siguientes componentes como dependencias externas:

*   **[yt-dlp](https://github.com/yt-dlp/yt-dlp)** (Licencia Unlicense / Public Domain): Se utiliza única y exclusivamente como un motor CLI externo para la obtención y streaming de URLs de audio de YouTube. Esta aplicación no contiene, modifica ni compila código de `yt-dlp`; únicamente invoca el binario oficial `yt-dlp.exe` provisto por su respectiva comunidad.
*   **[FFmpeg](https://ffmpeg.org)** (Licencia LGPL 2.1 / GPL): Utilizado para la decodificación, extracción y conversión de los flujos de audio al formato MP3 en alta calidad. `ffmpeg.exe` es invocado de manera externa.
*   **[Qt Framework](https://www.qt.io)** (Licencia LGPLv3): Usado para la interfaz gráfica mediante QML y la lógica de backend en C++.

---
*Desarrollado por [vamp9](https://github.com/lordvamp9)*

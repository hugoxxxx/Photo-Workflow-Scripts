@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

rem ======================================================
rem 6x6 Medium Format Film Border Tool / 6x6 中画幅画册边框工具
rem Version: 16.0 Master Version (Final)
rem Features: 2400px / Transparent Shadow / Smart EXIF Fallback
rem ======================================================

:loop
if "%~1"=="" goto end

echo --------------------------------------------------
echo [Processing / 正在处理]: %~nx1

rem --- [1. Generate Timestamp / 生成时间戳] ---
set "t=%time: =0%"
set "timestamp=%t:~0,2%%t:~3,2%%t:~6,2%"

rem --- [2. EXIF Data Extraction / 提取拍摄数据] ---
for /f "delims=" %%a in ('exiftool -s -s -s -Make "%~1"') do set Make=%%a
for /f "delims=" %%a in ('exiftool -s -s -s -Model "%~1"') do set Model=%%a
for /f "delims=" %%a in ('exiftool -s -s -s -LensModel "%~1"') do set Lens=%%a
for /f "delims=" %%a in ('exiftool -s -s -s -ExposureTime "%~1"') do set Shutter=%%a
for /f "delims=" %%a in ('exiftool -s -s -s -FNumber "%~1"') do set Aperture=%%a
for /f "delims=" %%a in ('exiftool -s -s -s -ImageDescription "%~1"') do set RawDesc=%%a

rem --- [3. Film Intelligence Matching / 胶卷库智能识别] ---
if "!RawDesc!"=="" (
    set "FilmName=CUSTOM FILM"
) else (
    for /f "tokens=1 delims=(" %%i in ("!RawDesc!") do set "FilmName=%%i"
    set "FinalFilm=!FilmName!"
    
    echo !FilmName! | findstr /I "Portra" | findstr "400" >nul && (set "FinalFilm=KODAK PORTRA 400" & goto :done_film)
    echo !FilmName! | findstr /I "Portra" | findstr "160" >nul && (set "FinalFilm=KODAK PORTRA 160" & goto :done_film)
    echo !FilmName! | findstr /I "Portra" | findstr "800" >nul && (set "FinalFilm=KODAK PORTRA 800" & goto :done_film)
    echo !FilmName! | findstr /I "E100" >nul && (set "FinalFilm=KODAK EKTACHROME E100" & goto :done_film)
    echo !FilmName! | findstr /I "Provia" >nul && (set "FinalFilm=FUJI PROVIA 100F" & goto :done_film)
    echo !FilmName! | findstr /I "Velvia" | findstr "50" >nul && (set "FinalFilm=FUJI VELVIA 50" & goto :done_film)
    echo !FilmName! | findstr /I "Ektar" >nul && (set "FinalFilm=KODAK EKTAR 100" & goto :done_film)
    echo !FilmName! | findstr /I "Gold" >nul && (set "FinalFilm=KODAK GOLD 200" & goto :done_film)
    echo !FilmName! | findstr /I "Tri-X" >nul && (set "FinalFilm=KODAK TRI-X 400" & goto :done_film)
    echo !FilmName! | findstr /I "HP5" >nul && (set "FinalFilm=ILFORD HP5 PLUS 400" & goto :done_film)
    echo !FilmName! | findstr /I "FP4" >nul && (set "FinalFilm=ILFORD FP4 PLUS 125" & goto :done_film)

    :done_film
    set "FilmName=!FinalFilm!"
    for /l %%k in (1,1,4) do if "!FilmName:~-1!"==" " set "FilmName=!FilmName:~0,-1!"
)

rem --- [4. Smart EXIF Fallback / 缺失数据智能排版判断] ---
set "CameraBrand=!Make! !Model!"
if /I "!Make!"=="Hasselblad" set "CameraBrand=HASSELBLAD !Model!"

if "!Shutter!"=="" (
    if "!Aperture!"=="" (
        rem 情况 A: 快门光圈都缺失，只显示镜头和胶卷
        set "InfoLine=!Lens!  |  !FilmName!"
    ) else (
        rem 情况 B: 只有快门缺失
        set "InfoLine=!Lens!  |  f/!Aperture!  |  !FilmName!"
    )
) else (
    if "!Aperture!"=="" (
        rem 情况 C: 只有光圈缺失
        set "InfoLine=!Lens!  |  !Shutter!s  |  !FilmName!"
    ) else (
        rem 情况 D: 数据完整
        set "InfoLine=!Lens!  |  !Shutter!s f/!Aperture!  |  !FilmName!"
    )
)

rem --- [5. Professional Rendering / 艺术渲染渲染] ---
magick "%~1" -resize 2400x2400 ^
 -bordercolor white -border %%[fx:w*0.04] ^
 -background white -gravity South -splice 0x%%[fx:h*0.13] ^
 -font "Palatino-Linotype-Bold" -fill "#1a1a1a" -kerning 6 -pointsize %%[fx:w*0.032] ^
 -annotate +0+%%[fx:h*0.078] "!CameraBrand!" ^
 -font "Garamond" -fill "#555" -kerning 4 -pointsize %%[fx:w*0.024] ^
 -annotate +0+%%[fx:h*0.040] "!InfoLine!" ^
 -bordercolor "#eee" -border 1 ^
 ( +clone -background black -shadow 60x25+0+15 ) +swap ^
 -background none -layers merge +repage ^
 -define png:compression-level=9 ^
 "%~dp1%~n1_Border_!timestamp!.png"

echo [Success / 完成]: %~n1_Border_!timestamp!.png
shift
goto loop

:end
echo --------------------------------------------------
echo [All tasks completed / 所有任务已完成]
pause
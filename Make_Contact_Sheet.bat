@echo off
rem --- Set environment for UTF-8 support / 设置环境支持UTF-8编码 ---
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ======================================================
echo    Film Contact Sheet Generator - v2.6.7 (Clean)
echo ======================================================

rem --- [1. Statistics / 统计] ---
set "first_file="
set "count=0"
set "RawDesc=CUSTOM FILM"
for %%x in (*.jpg *.png *.tif) do (
    set /a count+=1
    if "!first_file!"=="" (
        set "first_file=%%x"
        for /f "delims=" %%a in ('exiftool -s -s -s -ImageDescription "%%x"') do set "RawDesc=%%a"
    )
)
if "!first_file!"=="" (echo [ERROR] No images found. & pause & exit)

rem --- [2. Film Stock Library Matching / 胶卷库匹配] ---
set "FilmName="
set "TargetName=!RawDesc!"
:MatchLoop
set "TN=!TargetName!"
echo "!TN!" | findstr /I "Portra" | findstr "400" >nul && (set "FilmName=KODAK PORTRA 400" & goto :DateCheck)
echo "!TN!" | findstr /I "Portra" | findstr "160" >nul && (set "FilmName=KODAK PORTRA 160" & goto :DateCheck)
echo "!TN!" | findstr /I "Ektar" >nul && (set "FilmName=KODAK EKTAR 100" & goto :DateCheck)
echo "!TN!" | findstr /I "Gold" >nul && (set "FilmName=KODAK GOLD 200" & goto :DateCheck)
echo "!TN!" | findstr /I "Tri-X" >nul && (set "FilmName=KODAK TRI-X 400" & goto :DateCheck)
echo "!TN!" | findstr /I "TMAX" | findstr "100" >nul && (set "FilmName=KODAK T-MAX 100" & goto :DateCheck)
echo "!TN!" | findstr /I "TMAX" | findstr "400" >nul && (set "FilmName=KODAK T-MAX 400" & goto :DateCheck)
echo "!TN!" | findstr /I "E100" >nul && (set "FilmName=KODAK EKTACHROME 100" & goto :DateCheck)
echo "!TN!" | findstr /I "Provia" >nul && (set "FilmName=FUJI PROVIA 100F" & goto :DateCheck)
echo "!TN!" | findstr /I "Velvia" | findstr "50" >nul && (set "FilmName=FUJI VELVIA 50" & goto :DateCheck)
echo "!TN!" | findstr /I "Velvia" | findstr "100" >nul && (set "FilmName=FUJI VELVIA 100" & goto :DateCheck)
echo "!TN!" | findstr /I "Astia" >nul && (set "FilmName=FUJI ASTIA 100F" & goto :DateCheck)
echo "!TN!" | findstr /I "400H" >nul && (set "FUJI PRO 400H" & goto :DateCheck)
echo "!TN!" | findstr /I "160NS" >nul && (set "FilmName=FUJI 160NS" & goto :DateCheck)
echo "!TN!" | findstr /I "HP5" >nul && (set "FilmName=ILFORD HP5 PLUS" & goto :DateCheck)
echo "!TN!" | findstr /I "FP4" >nul && (set "FilmName=ILFORD FP4 PLUS" & goto :DateCheck)
echo "!TN!" | findstr /I "Delta" | findstr "100" >nul && (set "FilmName=ILFORD DELTA 100" & goto :DateCheck)
echo "!TN!" | findstr /I "Delta" | findstr "400" >nul && (set "FilmName=ILFORD DELTA 400" & goto :DateCheck)

if "!Interacted!"=="YES" (set "FilmName=!TargetName!" & goto :DateCheck)

:UserInteraction
set "Interacted=YES"
echo.
echo [UNRECOGNIZED] Raw Info: "!TargetName!"
echo [ACTION] Enter shorthand (e.g., gold200) or press Enter to keep raw:
set /p "UserInput=> "
if "!UserInput!"=="" (set "FilmName=!TargetName!" & goto :DateCheck)
set "TargetName=!UserInput!"
goto :MatchLoop

:DateCheck
rem --- [3. Smart Title Logic / 智能标题逻辑] ---
for /f "delims=" %%a in ('exiftool -s -s -s -Model "!first_file!"') do set "Model=%%a"
for /f "delims=" %%a in ('exiftool -d "%%Y-%%m-%%d" -s -s -s -DateTimeOriginal "!first_file!"') do set "CleanDate=%%a"

set "DisplayDate="
if "!CleanDate!"=="" (
    echo [MISSING] Date not found. Enter YYYY-MM-DD or press Enter to skip:
    set /p "InDate=> "
    if "!InDate!"=="" (
        set "CleanDate=UNKNOWN"
        set "DisplayDate="
    ) else (
        set "CleanDate=!InDate!"
        set "DisplayDate=  ^|  !CleanDate!"
    )
) else (
    :: 格式化显示日期 / Format display date
    set "DisplayDate=  ^|  !CleanDate:~0,7!"
)

rem 动态组合标题：相机 | 胶片 [| 日期] | 张数
rem Dynamic Title: Model | Film [| Date] | Count
set "MainTitle=!Model!  ^|  !FilmName!!DisplayDate!  ^|  !count! Frames"

rem --- [4. Visual Style] ---
set "BGColor=#F5F5F5"
set "UnifiedColor=#1A1A1A"
set "TextSize=52"
set "FooterHeight=240"

rem --- [5. Render Individual] ---
if exist ".temp_labels" rd /s /q ".temp_labels"
mkdir ".temp_labels"

for %%f in (*.jpg *.png *.tif) do (
    set "Shutter=" & set "Aperture=" & set "Lens="
    for /f "delims=" %%a in ('exiftool -s -s -s -LensModel "%%f"') do set "Lens=%%a"
    if "!Lens!"=="" for /f "delims=" %%a in ('exiftool -s -s -s -Lens "%%f"') do set "Lens=%%a"
    if "!Lens!"=="" set "Lens=Standard Lens"
    for /f "delims=" %%a in ('exiftool -s -s -s -ExposureTime "%%f"') do set "Shutter=%%a"
    for /f "delims=" %%a in ('exiftool -s -s -s -FNumber "%%f"') do set "Aperture=%%a"
    
    set "ParamLine="
    if not "!Shutter!"=="" (
        if not "!Aperture!"=="" (set "ParamLine=!Shutter!s  f/!Aperture!") else (set "ParamLine=!Shutter!s")
    ) else (
        if not "!Aperture!"=="" (set "ParamLine=f/!Aperture!")
    )

    magick "%%f" -resize 1200x1200 ^
        -background "!BGColor!" -gravity center -extent 1200x1200 ^
        -background "!BGColor!" -gravity South -splice 0x!FooterHeight! ^
        -font "Garamond-Bold" -fill "!UnifiedColor!" -pointsize !TextSize! -annotate +0+140 "!Lens!" ^
        -font "Garamond-Bold" -fill "!UnifiedColor!" -pointsize !TextSize! -annotate +0+60 "!ParamLine!" ^
        ".temp_labels\%%~nf.miff"
)

rem --- [6. Assembly] ---
set "Tile=3x4"
if !count! GTR 12 set "Tile=4x4"
if !count! GTR 16 set "Tile=5x7"
if !count! GTR 35 set "Tile=6x6"

magick montage ".temp_labels\*.miff" ^
    -geometry +40+40 ^
    -background "!BGColor!" ^
    -tile !Tile! ^
    -title "!MainTitle!" ^
    -fill "!UnifiedColor!" ^
    -font "Palatino-Linotype-Bold" -pointsize 65 ^
    "ContactSheet_!CleanDate!_Light.jpg"

rd /s /q ".temp_labels"
echo [SUCCESS] Clean Layout Contact Sheet Generated!
pause
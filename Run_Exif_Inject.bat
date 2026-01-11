@echo off
:: 设置窗口标题 / Set window title
title Run_Exif_Inject - ExifTool Workflow

:: 强制切换为 UTF-8 / Switch to UTF-8
chcp 65001 >nul

echo ======================================================
echo [Workflow] 正在执行：胶片元数据批量注入
echo [Workflow] Running: Batch Film Metadata Injection
echo ======================================================

:: 检查配置文件是否存在
:: Check if 1.json exists
if not exist "1.json" (
    echo [Error] 错误：未找到 1.json
    echo [Error] Error: 1.json not found.
    pause
    exit /b
)

:: 执行 ExifTool 注入
:: 删除了 -ext 限制，处理目录下所有支持的格式
:: Removed -ext limits, processing all supported formats
exiftool -json="1.json" "." -overwrite_original

echo.
echo ------------------------------------------------------
echo [Done] 任务完成！/ Task Completed!
echo ------------------------------------------------------
pause
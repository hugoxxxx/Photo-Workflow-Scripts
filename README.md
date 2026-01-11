# 📸 Photo-Workflow-Scripts | 摄影后期自动化脚本集

A professional batch processing toolkit for film photographers. Streamline your workflow from **Lightme** metadata injection to high-quality **border rendering** and **contact sheet generation**.  
一套专为胶片摄影师设计的专业批处理工具集。简化从 **Lightme** 测光数据注入到高品质 **边框渲染** 及 **全卷预览生成** 的全流程工作流。

---

## 🎞️ 功能特性 | Features

* **EXIF Metadata Injection | EXIF 数据注入**:  
    Batch inject camera model, lens, and exposure data via JSON templates exported from Lightme.  
    通过 Lightme 导出的 JSON 模板，批量为扫描件注入拍摄机型、镜头及曝光参数。

* **Gallery-Style Borders | 画廊级边框绘制**:  
    Automatically matches film names from the v18.1 library and generates professional borders with metadata tags.  
    自动根据 v18.1 胶卷库匹配官方全称，并生成带参数标识的专业艺术边框。

* **Contact Sheet Generation | 全卷预览图生成 (v2.6.7)**:  
    Smartly organizes entire rolls into a clean grid. Supports mixed orientations (Horizontal/Vertical) with auto-alignment and graceful metadata degradation.  
    智能拼接整卷底片。支持横竖构图混排自动对齐，并提供优雅的元数据缺失处理逻辑（无日期时不显示空占位符）。

---

## 🖼️ 效果预览 | Sample Output

### 1. 全卷预览印相页 | Film Contact Sheet (v2.6.7)
**EN**: Balanced grid layout for entire rolls, supporting mixed orientations with auto-aligned captions.  
**CN**: 整卷底片均衡网格布局，支持横竖构图混排，并确保标注文字整齐对齐。

<p align="center">
  <img src="https://github.com/hugoxxxx/Photo-Workflow-Scripts/raw/main/sample/contact_sheet_sample.jpg" width="90%" />
</p>

### 2. 单张边框渲染 | Single Frame Border Rendering
**EN**: High-quality metadata border with automatic film stock matching.  
**CN**: 带有胶卷型号自动匹配的高品质元数据边框。

<p align="center">
  <img src="https://github.com/hugoxxxx/Photo-Workflow-Scripts/raw/main/sample/after.png" width="60%" />
</p>

---

## 🚀 详细使用方案 | Detailed Usage Guide

### 1. 环境准备 | Prerequisites
* **Install Tools**: Ensure **ExifTool** and **ImageMagick** are installed and added to your system `PATH`.
    **安装工具**：确保已安装 **ExifTool** 和 **ImageMagick**，并将其路径添加至系统环境变量。
* **File Naming**: Ensure your scans are named sequentially (e.g., `01.jpg`, `02.jpg`) for the best contact sheet order.
    **文件命名**：建议将扫描件按顺序命名（如 `01.jpg`），以获得最佳的全卷预览排序。

### 2. 工作流步骤 | Workflow Steps

#### **Step A: Metadata Injection | 第一步：元数据注入**
* **Scenario**: You have a JSON file from Lightme but your scans have no EXIF.
    **场景**：你有 Lightme 的记录但扫描件没有 EXIF 信息。
* **Action**: Place `Run_Exif_Inject.bat` and `1.json` in your image folder, then run the script.
    **操作**：将脚本和 `1.json` 放入照片文件夹，运行脚本。

#### **Step B: Create Contact Sheet | 第二步：生成全卷预览**
* **Scenario**: You want a gallery-style index of the entire roll for archiving.
    **场景**：你需要一张画廊风格的全卷索引页用于归档。
* **Action**: Run `Make_Contact_Sheet.bat`. The script automatically handles grid size (3x4 to 6x6) based on frame count.
    **操作**：运行脚本。脚本会根据照片张数自动匹配网格尺寸（从 3x4 到 6x6）。

#### **Step C: Border Rendering | 第三步：边框渲染**
* **Scenario**: You want to export a single frame for social media with classic film borders.
    **场景**：你需要导出单张带经典胶卷边框的照片发社交媒体。
* **Action**: Drag files onto `6x6_Border_Tool.bat`. If unrecognized, type shorthand (e.g., `gold200`) to match.
    **操作**：将文件拖拽至脚本图标。若未识别，输入简称（如 `gold200`）匹配即可。

---

## 💻 脚本逻辑示例 | Script Logic Snippets

### Smart Date Handling | 智能日期处理
```batch
:: EN: Hide date separator if no date is provided to keep the title clean
:: CN: 若无日期信息，则自动隐藏日期及分隔符，保持标题纯净
if "!CleanDate!"=="" (
    set "DisplayDate="
) else (
    set "DisplayDate=  ^|  !CleanDate:~0,7!"
)
set "MainTitle=!Model!  ^|  !FilmName!!DisplayDate!  ^|  !count! Frames"

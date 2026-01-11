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

## 🛠️ 脚本说明 | Scripts

| Script Name | Description | Version |
| :--- | :--- | :--- |
| `Run_Exif_Inject.bat` | Batch inject EXIF based on JSON | v1.0 |
| `6x6_Border_Tool.bat` | Add 120/135 borders to single frames | v18.1 |
| **`Make_Contact_Sheet.bat`** | **Generate clean, balanced film contact sheets** | **v2.6.7** |

---

## 🚀 快速使用 | Quick Start

### 1. 准备数据 | Data Preparation
* **EN**: Export your record from Lightme. **Please rename the exported JSON to `1.json`** and place it in the same folder as your scans.
* **CN**: 从 Lightme 导出记录。**请务必将导出的 JSON 重命名为 `1.json`** 并存放在扫描件文件夹下。

### 2. 执行注入 | Inject Metadata
* **EN**: Run `Run_Exif_Inject.bat`. It will match `1.json` entries with your image filenames and update the EXIF data.
* **CN**: 运行 `Run_Exif_Inject.bat`。脚本会匹配 `1.json` 中的条目与文件名，并更新 EXIF 元数据。

### 3. 全卷预览 | Generate Contact Sheet
* **EN**: Run `Make_Contact_Sheet.bat`. It will create an elegant off-white contact sheet. Missing metadata (Date/Exposure) will be handled gracefully without showing empty placeholders.
* **CN**: 运行 `Make_Contact_Sheet.bat`。脚本将生成一张烟白色调的预览大图，并自动隐藏缺失的日期或曝光信息。

### 4. 渲染边框 | Render Borders
* **EN**: Drag and drop your images onto `6x6_Border_Tool.bat`. If a film stock is unrecognized, simply type a shorthand (e.g., `v50` for Velvia 50) to match.
* **CN**: 将图片直接 **拖拽** 到 `6x6_Border_Tool.bat` 上。若胶卷未识别，输入简称（如 `v50` 代表 Velvia 50）即可完成匹配。

---

## 🖼️ 效果预览 | Sample Output

**EN**: Mixed orientation contact sheet (v2.6.7) ensures a perfect grid with aligned captions.  
**CN**: 混合构图预览图 (v2.6.7) 确保网格线与标签文字完美对齐。

<br>

<p align="center">
  <img src="https://github.com/hugoxxxx/Photo-Workflow-Scripts/raw/main/sample/before.jpg" width="42%" align="top" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/hugoxxxx/Photo-Workflow-Scripts/raw/main/sample/after.png" width="48.5%" align="top" />
</p>

<p align="center">
  <font color="#888">Left: Raw Scan | Right: Metadata & Border Rendering</font>
</p>

---

## ⚙️ 环境依赖 | Dependencies

* **ExifTool**: [Download](https://exiftool.org/) and rename the executable to `exiftool.exe`. (下载并更名为 `exiftool.exe`)
* **ImageMagick**: [Download](https://imagemagick.org/) and ensure the `magick` command is available in your PATH. (确保安装并使 `magick` 命令全局可用)

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

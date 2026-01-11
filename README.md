# 📸 Photo-Workflow-Scripts | 摄影后期自动化脚本集

A professional batch processing toolkit for medium format film photographers. Streamline your workflow from **Lightme** metadata injection to high-quality **border rendering**.

一套专为中画幅胶片摄影师设计的专业批处理工具集。简化从 **Lightme** 测光数据注入到高品质 **边框渲染** 的全流程工作流。

---

## 🛠️ 工具说明 (Included Tools)

### 1. Run_Exif_Inject.bat
* **EN**: Metadata injector optimized for **Lightme App** records. It automatically writes shutter speed, aperture, lens info, and film stock into your scans (JPG/TIF/DNG).
* **CN**: 针对 **Lightme App** 记录优化的元数据注入器。自动将快门、光圈、镜头及胶卷型号批量写入扫描件（支持 JPG/TIF/DNG）。

### 2. 6x6 Medium Format Film Border Tool.bat (v18.1 Pro)
* **EN**: A sophisticated 6x6 border engine. It features a built-in film library to standardize stock names (e.g., "160ns" → "FUJI 160NS") and renders elegant typography with soft drop shadows using ImageMagick.
* **CN**: 职业级 6x6 边框渲染引擎。内置胶卷库自动标准化名称（如 "160ns" 转换为 "FUJI 160NS"），并利用 ImageMagick 生成带柔和投影的优雅排版。

---

## 🚀 快速使用 (Quick Start)

### 1. 准备数据 (Data Preparation)
* **EN**: Export your record from Lightme. **Please rename the exported JSON to `1.json`** and place it in the same folder as your scans.
* **CN**: 从 Lightme 导出记录。**请务必将导出的 JSON 重命名为 `1.json`** 并存放在扫描件文件夹下。

### 2. 执行注入 (Inject Metadata)
* **EN**: Run `Run_Exif_Inject.bat`. It will match `1.json` entries with your image filenames and update the EXIF data.
* **CN**: 运行 `Run_Exif_Inject.bat`。脚本会匹配 `1.json` 中的条目与文件名，并更新 EXIF 元数据。

### 3. 渲染边框 (Render Borders)
* **EN**: Drag and drop your images onto `6x6 Medium Format Film Border Tool.bat`. 
* **CN**: 将图片直接 **拖拽** 到 `6x6 Medium Format Film Border Tool.bat` 脚本图标上。
* **EN**: If a film stock is unrecognized, a prompt will appear. Simply type a shorthand (e.g., `v50

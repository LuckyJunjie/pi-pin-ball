# 🎮 Game Assets 自动下载工具

**用途:** 自动下载免费游戏美术/音频资源
**工具:** curl, wget, aria2

---

## 📦 支持的资源网站

### 1. Kenney Assets (推荐)
- **网站:** https://kenney.nl/assets
- **许可证:** CC0 (免费商用)
- **下载方式:** 直接下载 .zip 文件

### 2. OpenGameArt
- **网站:** https://opengameart.org
- **许可证:** CC0, CC-BY, CC-BY-SA
- **下载方式:** 搜索页面获取下载链接

### 3. FreeSound
- **网站:** https://freesound.org
- **许可证:** 需检查各资源
- **下载方式:** API 或页面抓取

---

## 🚀 使用方法

### 下载 Kenney Pinball 资源
```bash
# 创建资源目录
mkdir -p assets/kenney

# 下载 Kenney Pinball (如果找到直接链接)
wget -O pinball.zip "https://kenney.nl/content/3-0/0/0/1/pinball.zip"

# 或使用 curl
curl -L -o pinball.zip "https://kenney.nl/content/3-0/0/0/1/pinball.zip"
```

### 批量下载资源
```bash
# 创建下载脚本
cat > download_assets.sh << 'EOF'
#!/bin/bash

# Kenney Assets
ASSETS=(
  "https://kenney.nl/content/3-0/0/0/1/pinball.zip"
)

for url in "${ASSETS[@]}"; do
  filename=$(basename "$url")
  echo "下载: $filename"
  curl -L -o "assets/$filename" "$url"
done
EOF
```

---

## 📋 常用资源列表

### 弹珠机相关
| 资源包 | 搜索关键词 | 备注 |
|--------|------------|------|
| Pinball | kenney.nl/assets?q=pinball | 弹珠机主题 |
| Arcade | kenney.nl/assets?q=arcade | 街机风格 |
| Space | kenney.nl/assets?q=space | 太空背景 |

### 2D 通用
| 资源包 | 搜索关键词 | 备注 |
|--------|------------|------|
| Platformer | kenney.nl/assets?q=platformer | 2D平台 |
| RPG | kenney.nl/assets?q=rpg | RPG素材 |
| UI | kenney.nl/assets?q=ui | UI界面包 |

### 音效
| 资源包 | 搜索关键词 | 备注 |
|--------|------------|------|
| Audio | kenney.nl/assets?q=audio | 音效合集 |
| 8-bit | opengameart.org 搜索 8-bit | 复古音效 |

---

## 🔧 自动化脚本

### 每日资源检查脚本
```bash
#!/bin/bash
# 检查新资源并下载

DATE=$(date +%Y-%m-%d)
LOG_FILE="download_log_$DATE.txt"

echo "=== 资源下载日志 $DATE ===" >> $LOG_FILE

# 检查 Kenney 新资源
echo "检查 Kenney..." >> $LOG_FILE
curl -s "https://kenney.nl/assets" | grep -i pinball >> $LOG_FILE 2>&1

echo "完成" >> $LOG_FILE
```

---

## 📁 资源存放结构

```
pi-pin-ball/
├── assets/
│   ├── kenney/          # Kenney 资源
│   │   └── pinball/
│   ├── opengameart/    # OpenGameArt 资源
│   └── custom/          # 自定义资源
├── sounds/              # 音效
│   ├── sfx/
│   └── music/
└── project.godot
```

---

*由 Vanguard001 创建 - 可自动执行下载任务*

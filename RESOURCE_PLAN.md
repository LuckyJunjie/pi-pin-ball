# PI-PinBall 资源获取计划

**角色:** TA-001 (技术美术), AUDIO-001 (音频工程师)  
**日期:** 2026-02-20

---

## ⚠️ 网络限制说明

由于当前环境网络受限，无法自动下载资源。**需要手动下载**以下资源：

---

## 免费美术资源

### 1. Kenney Assets (推荐)
- **Pinball Pack**: https://kenney.nl/assets/pinball-pack
- **Platformer Pack**: https://kenney.nl/assets/platformer-characters-1
- **Space Shooter**: https://kenney.nl/assets/space-shooter

### 2. OpenGameArt
- **Pinball Sprites**: https://opengameart.org/content/pinball-sprites
- **Space Pinball**: https://opengameart.org/content/space-pinball
- **Neon Platformer**: https://opengameart.org/content/neon-platformer

### 3. 通用素材
- **OpenClipArt**: https://openclipart.org
- **Game-Icons.net**: https://game-icons.net

---

## 免费音频资源

### 1. Freesound (需注册)
- https://freesound.org

### 2. OpenGameArt Audio
- **Arcade Music**: https://opengameart.org/content/arcade-music-pack
- **Retro Sounds**: https://opengameart.org/content/retro-sounds-pack

---

## 需要下载的资源清单

### 美术资源
| 资源名 | 用途 | 下载链接 |
|--------|------|----------|
| Pinball Pack | 弹珠机台面、障碍 | Kenney |
| Backgrounds | 游戏背景 | OpenGameArt |
| Effects | 得分特效 | Kenney |

### 音频资源
| 资源名 | 用途 | 下载链接 |
|--------|------|----------|
| BGM | 背景音乐 | OpenGameArt |
| SFX | 音效(发射/碰撞) | Freesound |

---

## 下载后放置位置

```
pi-pin-ball/
├── assets/
│   ├── sprites/        # 放置下载的Sprite
│   ├── backgrounds/    # 放置下载的背景图
│   ├── audio/
│   │   ├── music/     # 放置背景音乐
│   │   └── sfx/       # 放置音效
│   └── effects/        # 放置特效
```

---

## 游戏控制改进

### 问题
- 游戏界面无法操作
- 需要添加键盘/触摸控制

### 需要修复
- [ ] 左挡板: Left Arrow / A / 鼠标左区域
- [ ] 右挡板: Right Arrow / D / 鼠标右区域
- [ ] 发射: Space / 鼠标点击

---

## 手动资源下载步骤

1. 访问 https://kenney.nl/assets/pinball-pack
2. 点击 "Download"
3. 解压放到 `assets/` 目录

**完成后告诉我，我会帮你集成到游戏中！**

---

*最后更新: 2026-02-20*

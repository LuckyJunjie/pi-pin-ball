# PI-PinBall 待办任务

**创建时间:** 2026-02-20
**最后更新:** 2026-02-21 08:51
**状态:** 深度研究执行中 - 需要人工干预

---

## 🚨 阻塞任务 (需优先处理) - 更新

### 音频资源收集
- [x] 确认音效风格偏好 (复古 8-bit) ✅
- [ ] 创建 assets/audio/sfx/ 目录
- [ ] 创建 assets/audio/music/ 目录
- [ ] 下载/创建音效文件 (由 CodeForge 提交 Windows 上的资源)
  - [ ] launch.wav - 发射音效
  - [ ] flipper.wav - 挡板音效
  - [ ] collision.wav - 碰撞音效
  - [ ] score.wav - 得分音效
  - [ ] combo.wav - 连击音效
  - [ ] game_over.wav - 游戏结束音效
  - [ ] button_click.wav - 按钮点击音效
  - [ ] level_complete.wav - 关卡完成音效
  - [ ] background.mp3 - 背景音乐

### 角色系统集成
- [ ] 在 GameManager.start_game() 中调用 apply_special_ability()
- [ ] 在 Ball.gd 中实现 apply_speed_multiplier() 方法
- [ ] 在 Ball.gd 中实现 apply_score_multiplier() 方法
- [ ] 在 Ball.gd 中实现 enable_magnet() 方法
- [ ] 在 Ball.gd 中实现 add_life() 方法
- [ ] 测试特殊能力效果

### 🔧 基础设施
- [x] scripts/ 目录存在，包含 37 个 GDScript 文件 ✅
- [x] test/ 目录已创建，包含 7 个测试文件 ✅
- [ ] Git 推送到 origin (2 commits 本地领先) ⚠️

---

## 📋 短期任务 (本周)

### 主题区域完善
- [ ] 定义 Level 3 (Dino Desert) 主题配置
- [ ] 定义 Level 4 (Flutter Forest) 主题配置
- [ ] 定义 Level 5 (Sparky Scorch) 主题配置
- [ ] 创建对应主题的 ThemeArea.tscn 变体

### 测试套件
- [ ] 创建 test/ 目录
- [ ] 编写基础单元测试
- [ ] 编写集成测试
- [ ] 配置 CI 测试运行

---

## 🎯 中期任务 (下周)

### Flutter 功能复刻
- [ ] 实现 Multiball 机制
  - [ ] MultiballSpawner.gd
  - [ ] MultiballBall.tscn
  - [ ] Multiball 触发逻辑
- [ ] 实现 Multiplier 机制
  - [ ] MultiplierArea.gd
  - [ ] Multiplier 显示 UI
  - [ ] Multiplier 叠加逻辑

### 主题区域实现
- [ ] 实现 Dino Desert 主题区域
- [ ] 实现 Flutter Forest 主题区域
- [ ] 实现 Sparky Scorch 主题区域

---

## 🔧 维护任务 (持续)

- [ ] 修复已知 Bug
- [ ] 优化性能
- [ ] 更新文档
- [ ] 代码重构

---

## 📝 任务统计

| 类别 | 总数 | 未开始 | 进行中 | 已完成 |
|------|------|--------|--------|--------|
| 阻塞任务 | 12 | 12 | 0 | 0 |
| 短期任务 | 7 | 7 | 0 | 0 |
| 中期任务 | 7 | 7 | 0 | 0 |
| 维护任务 | 4 | 4 | 0 | 0 |
| **总计** | **30** | **30** | **0** | **0** |

---

## 📌 优先级说明

- 🚨 **阻塞**: 阻止核心功能实现，必须优先解决
- 📋 **短期**: 本周应完成的任务
- 🎯 **中期**: 下周计划任务
- 🔧 **维护**: 持续性任务

---

*文件由 Vanguard001 自动创建 (Cron: 27d02e6a-f9a5-450f-9351-ca624af742a0)*

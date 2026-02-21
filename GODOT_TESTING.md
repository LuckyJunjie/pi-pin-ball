# Godot 自动化测试方案

**基于 GdUnit4 + GDSnap 的测试框架**

---

## 概述

本文档描述如何使用 Godot 生态中的专业测试工具实现类似 Jest 的自动化测试体验。

---

## 核心工具

### 1. GdUnit4 - 测试框架

**类比:** Jest (JavaScript)

**功能:**
- 单元测试和集成测试
- Headless 模式支持
- 场景模拟 (Scene Runner)
- 生成 JUnit/HTML 报告

**安装:**
```bash
# 通过 AssetLib 安装
# 在 Godot 编辑器中: AssetLib -> 搜索 "GdUnit4"
```

### 2. GDSnap - 截图对比

**类比:** jest-image-snapshot (Jest)

**功能:**
- 保存基准截图
- 自动比对差异
- 高亮显示变化区域

**安装:**
```bash
# 通过 AssetLib 安装
# 在 Godot 编辑器中: AssetLib -> 搜索 "GDSnap"
```

---

## 组合使用方案

### 测试流程

```
1. 准备基准图
   ↓
2. Scene Runner 操作游戏
   ↓
3. 截图对比
   ↓
4. 生成报告
```

### 示例测试用例

```gdscript
# test_pinball.gd
extends GdUnitTest

func test_ball_launch() -> void:
    # 1. 加载游戏场景
    var scene = load("res://scenes/Main.tscn").instantiate()
    add_child(scene)
    
    # 2. 等待场景初始化
    await get_tree().process_frame
    
    # 3. 模拟按下发射键
    var input = InputEventAction.new()
    input.action = "ui_accept"
    input.pressed = true
    Input.parse_input_event(input)
    
    # 4. 等待球发射
    await get_tree().create_timer(1.0).timeout
    
    # 5. 截图并比对
    GDSnap.take_screenshot("ball_launched")
    
    # 6. 断言
    assert_that(scene.get_node("Ball")).is_not_null()
```

---

## 在 CI/CD 中运行

### 命令行

```bash
# 运行所有测试
godot --path <project> --headless -s <godot>/addons/gdunit4/bin/gdunit4_cmdline.gd -t+

# 生成报告
godot --path <project> --headless -s <godot>/addons/gdunit4/bin/gdunit4_cmdline.gd -r junit -o ./reports/
```

### GitHub Actions

```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v3
        with:
          python-version: '3.11'
      - name: Download Godot
        run: |
          wget -q https://github.com/godotengine/godot/releases/download/4.2.1-stable/Godot_v4.2.1-stable_linux.x86_64.zip
          unzip Godot_v4.2.1-stable_linux.x86_64.zip
      - name: Run Tests
        run: |
          ./Godot_v4.2.1-stable_linux.x86_64 --headless -s addons/gdunit4/bin/gdunit4_cmdline.gd -t+
      - name: Upload Reports
        uses: actions/upload-artifact@v3
        with:
          name: test-reports
          path: reports/
```

---

## 实现步骤

### 1. 安装 GdUnit4
1. 打开 Godot 项目
2. AssetLib 搜索 "GdUnit4"
3. 下载并安装

### 2. 安装 GDSnap
1. AssetLib 搜索 "GDSnap"
2. 下载并安装

### 3. 创建测试场景
1. 创建 `test/` 目录
2. 编写测试脚本

### 4. 配置 CI/CD
1. 添加 GitHub Actions
2. 配置报告生成

---

## 当前状态

- **PI-PinBall:** 使用手动 PowerShell 截图测试
- **pin-ball:** 使用手动 PowerShell 截图测试
- **待实现:** GdUnit4 + GDSnap 自动化测试

---

## 下一步

1. 在项目中安装 GdUnit4
2. 编写自动化测试用例
3. 配置 CI/CD

---

*最后更新: 2026-02-20*

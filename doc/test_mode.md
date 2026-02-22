# Godot 测试模式

## 概述

为PI-PinBall添加测试模式，允许绕过主菜单直接进入游戏，用于自动化测试。

## 实现方式

### 1. 命令行参数测试模式

在 `project.godot` 中添加启动参数:

```
--testmode        # 直接进入游戏场景
--testscene=xxx  # 直接进入指定场景
--headless        # 无头模式(无窗口)
```

### 2. 项目内测试标志

创建 `TestManager.gd` 单例:

```gdscript
# TestManager.gd - 测试模式管理器
extends Node

## 测试模式标志
var test_mode: bool = false
var test_scene: String = ""

func _ready() -> void:
    # 解析启动参数
    var args = OS.get_cmdline_args()
    for arg in args:
        if arg == "--testmode":
            test_mode = true
        elif arg.begins_with("--testscene="):
            test_scene = arg.replace("--testscene=", "")

## 获取测试场景路径
func get_test_scene_path() -> String:
    if test_scene:
        return "res://scenes/" + test_scene + ".tscn"
    return "res://scenes/Main.tscn"  # 默认游戏场景
```

### 3. 修改 Main.gd 支持测试模式

```gdscript
func _ready() -> void:
    # 检查是否为测试模式
    var test_mgr = get_node_or_null("/root/TestManager")
    if test_mgr and test_mgr.test_mode:
        print("[Main] 测试模式: 直接开始游戏")
        _start_test_game()
        return
    
    # 正常流程
    _setup_normal_game()

func _start_test_game() -> void:
    # 直接初始化游戏
    GameManager.start_game()
    if launcher:
        launcher.launch()
```

## Godot MCP 集成

### 启动游戏并测试

```bash
# 1. 启动编辑器
godot_execute(tool="editor.play")

# 2. 模拟点击开始按钮 (通过坐标)
godot_execute(tool="input.mouseClick", parameters={x: 576, y: 350, button: "left"})

# 3. 等待场景切换
# (在代码中添加延迟或等待信号)

# 4. 截图验证
godot_execute(tool="debug.screenshot")

# 5. 获取控制台日志
godot_execute(tool="console.getLogs", parameters={limit: 50})

# 6. 停止游戏
godot_execute(tool="editor.stop")
```

### 自动化测试脚本

```bash
#!/bin/bash
# test_with_mcp.sh - 使用MCP进行自动化测试

echo "=== PI-PinBall 自动化测试 ==="

# 启动游戏
echo "1. 启动游戏..."
godot_execute tool=editor.play

# 等待启动
sleep 2

# 点击开始按钮 (需要根据实际按钮位置调整坐标)
echo "2. 点击开始按钮..."
godot_execute tool=input.mouseClick parameters='{"x": 576, "y": 320, "button": "left"}'

# 等待场景切换
sleep 1

# 截图
echo "3. 截图验证..."
godot_execute tool=debug.screenshot

# 获取日志
echo "4. 获取日志..."
godot_execute tool=console.getLogs parameters='{"limit": 30}'

# 停止
echo "5. 停止游戏..."
godot_execute tool=editor.stop

echo "=== 测试完成 ==="
```

## 测试用例示例

### 场景切换测试

```gdscript
# test/integration/test_scene_transition.gd
extends GutTest

func test_main_menu_to_game_with_test_mode():
    # 使用测试模式直接进入游戏
    var test_mgr = TestManager.new()
    test_mgr.test_mode = true
    get_tree().root.add_child(test_mgr)
    
    # 加载Main场景
    var main = load("res://scenes/Main.tscn").instantiate()
    get_tree().root.add_child(main)
    await get_tree().process_frame
    
    # 验证游戏已启动
    var gm = GameManager.get_instance()
    assert_true(gm.is_playing(), "测试模式下游戏应自动开始")
    
    main.free()
    test_mgr.free()
```

### 输入测试

```gdscript
func test_flipper_input():
    var main = load("res://scenes/Main.tscn").instantiate()
   .add_child(main)
    get_tree().root await get_tree().process_frame
    
    # 模拟按下左挡板键
    Input.action_press("ui_left")
    await get_tree().process_frame
    
    var left_flipper = main.get_node("LeftFlipper")
    assert_true(left_flipper.is_pressed(), "左挡板应被按下")
    
    Input.action_release("ui_left")
    main.free()
```

## CI/CD 集成

```yaml
# .github/workflows/test.yml
name: Automated Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Godot
        uses: heroiclabs/godot-action@v1
        with:
          godot-version: '4.5'
      
      - name: Run in Test Mode
        run: |
          godot --headless --testmode --path .
      
      - name: Upload Screenshots
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: test-screenshots
          path: screenshots/
```

---

*更新于: 2026-02-22*

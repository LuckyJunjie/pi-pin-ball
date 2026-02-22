# 控制台测试

## 概述

控制台测试是最轻量级的测试方式，通过日志输出验证游戏逻辑。适合快速验证和调试。

## 实现方式

### 1. 打印测试日志

```gdscript
# test_console.gd
extends GutTest

func test_flipper_rotation_speed() -> void:
    var flipper = Flipper.new()
    flipper.rotation_speed = 1500
    
    # 控制台输出验证
    print("=== 测试: 挡板旋转速度 ===")
    print("期望值: 1500 度/秒")
    print("实际值: ", flipper.rotation_speed, " 度/秒")
    
    if flipper.rotation_speed == 1500:
        print("✅ 测试通过!")
    else:
        print("❌ 测试失败!")
    
    assert_eq(flipper.rotation_speed, 1500)
```

### 2. 测试运行器 - 带详细日志

```gdscript
# run_tests_with_logging.gd
extends GutTest

func before_each() -> void:
    print("\n" + "=".repeat(50))
    print("开始测试: ", get_current_test_name())
    print("=".repeat(50))

func after_each() -> void:
    print("测试结束: ", get_current_test_name())
    print("-".repeat(50))
```

### 3. 场景切换调试测试

```gdscript
# test_scene_debug.gd
extends GutTest

func test_scene_transition_with_logging() -> void:
    print("\n[测试] 场景切换测试开始")
    
    # 加载主菜单
    print("[测试] 加载主菜单场景...")
    var menu = load("res://scenes/ui/MainMenu.tscn")
    if not menu:
        print("[错误] 无法加载主菜单场景!")
        assert(false, "无法加载主菜单场景")
        return
    
    var menu_instance = menu.instantiate()
    get_tree().root.add_child(menu_instance)
    await get_tree().process_frame
    print("[测试] 主菜单已加载")
    
    # 获取开始按钮
    var start_button = menu_instance.get_node_or_null("MarginContainer/VBoxContainer/ButtonContainer/StartButton")
    if not start_button:
        print("[错误] 找不到开始按钮!")
        assert(false, "找不到开始按钮")
        menu_instance.free()
        return
    
    print("[测试] 找到开始按钮: ", start_button.name)
    
    # 模拟点击
    print("[测试] 模拟点击开始按钮...")
    start_button.pressed.emit()
    await get_tree().process_frame
    await get_tree().process_frame
    
    # 检查场景
    var current_scene = get_tree().current_scene
    print("[测试] 当前场景: ", current_scene.name if current_scene else "null")
    
    # 验证
    if current_scene and current_scene.name == "Main":
        print("✅ 场景切换成功!")
    else:
        print("❌ 场景切换失败!")
        # 打印所有子场景
        print("[调试] 根节点子场景数量: ", get_tree().root.get_child_count())
        for i in range(get_tree().root.get_child_count()):
            var child = get_tree().root.get_child(i)
            print("  [", i, "] ", child.name)
    
    menu_instance.free()
```

### 4. 自动化控制台测试脚本

```bash
#!/bin/bash
# run_console_tests.sh - 运行测试并捕获控制台输出

echo "=========================================="
echo "PI-PinBall 控制台测试"
echo "=========================================="

cd /home/pi/.openclaw/workspace/pi-pin-ball

# 运行测试，捕获所有输出
godot --headless --path . -s test/run_tests.gd 2>&1 | tee test_output.log

# 分析输出
echo ""
echo "=========================================="
echo "测试结果分析"
echo "=========================================="

PASSED=$(grep -c "✅" test_output.log 2>/dev/null || echo "0")
FAILED=$(grep -c "❌" test_output.log 2>/dev/null || echo "0")
ERRORS=$(grep -c "\[错误\]" test_output.log 2>/dev/null || echo "0")

echo "通过: $PASSED"
echo "失败: $FAILED"
echo "错误: $ERRORS"

if [ "$FAILED" -gt 0 ] || [ "$ERRORS" -gt 0 ]; then
    echo ""
    echo "失败/错误的测试:"
    grep -E "\[错误\]|❌" test_output.log
    exit 1
else
    echo ""
    echo "✅ 所有测试通过!"
    exit 0
fi
```

### 5. CI/CD 集成

```yaml
# .github/workflows/console-test.yml
name: Console Tests

on: [push, pull_request]

jobs:
  console-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Godot
        uses: heroiclabs/godot-action@v1
        with:
          godot-version: '4.5'
      
      - name: Run Console Tests
        run: |
          godot --headless --path . -s test/run_tests.gd 2>&1 | tee test.log
      
      - name: Parse Results
        run: |
          echo "## 测试结果" >> $GITHUB_STEP_SUMMARY
          echo "✅ 通过: $(grep -c '测试通过' test.log)" >> $GITHUB_STEP_SUMMARY
          echo "❌ 失败: $(grep -c '测试失败' test.log)" >> $GITHUB_STEP_SUMMARY
      
      - name: Upload Logs
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: test-logs
          path: test.log
```

## 测试日志格式

建议统一日志格式便于解析:

```
[TEST] <测试名称> - 开始/通过/失败
[DEBUG] <调试信息>
[ERROR] <错误信息>
[SCENE] <场景信息>
```

## 快速验证命令

```bash
# 运行特定测试
godot --headless -s test/run_tests.gd --test <test_name>

# 只运行场景切换测试
godot --headless --path . -s test/integration/test_scene_transition.gd

# 捕获错误
godot --headless --path . 2>&1 | grep -E "ERROR|错误"
```

---

*更新于: 2026-02-22*

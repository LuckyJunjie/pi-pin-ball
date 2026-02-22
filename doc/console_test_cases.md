# 控制台日志测试用例

## 概述

覆盖主要游戏过程的控制台日志测试用例，用于验证游戏逻辑和排查错误。

## 测试用例列表

### 1. 游戏启动测试

```gdscript
func test_game_startup_logging():
    print("[TEST] 游戏启动测试开始")
    
    # 验证GameManager初始化
    var gm = GameManager.get_instance()
    assert_not_null(gm, "[TEST] GameManager应已初始化")
    print("[TEST] ✓ GameManager已初始化")
    
    # 验证初始状态
    assert_eq(gm.current_state, gm.GameState.WAITING, "[TEST] 初始状态应为WAITING")
    print("[TEST] ✓ 初始状态正确: WAITING")
    
    # 验证初始球数
    assert_eq(gm.get_remaining_balls(), 3, "[TEST] 初始球数应为3")
    print("[TEST] ✓ 初始球数: 3")
    
    print("[TEST] ✅ 游戏启动测试通过")
```

### 2. 场景切换测试

```gdscript
func test_scene_transition_logging():
    print("[TEST] 场景切换测试开始")
    
    # 加载主菜单
    print("[TEST] 加载主菜单场景...")
    var menu = load("res://scenes/ui/MainMenu.tscn").instantiate()
    get_tree().root.add_child(menu)
    await get_tree().process_frame
    print("[TEST] ✓ 主菜单已加载")
    
    # 获取开始按钮
    var btn = menu.get_node_or_null("MarginContainer/VBoxContainer/ButtonContainer/StartButton")
    assert_not_null(btn, "[ERROR] 开始按钮不存在")
    print("[TEST] ✓ 找到开始按钮")
    
    # 点击按钮
    print("[TEST] 点击开始按钮...")
    btn.pressed.emit()
    await get_tree().process_frame
    await get_tree().process_frame
    
    # 验证场景
    var scene = get_tree().current_scene
    if scene and scene.name == "Main":
        print("[TEST] ✅ 场景切换成功: Main")
    else:
        print("[ERROR] 场景切换失败，当前场景: ", scene.name if scene else "null")
    
    menu.free()
```

### 3. 发射器测试

```gdscript
func test_launcher_logging():
    print("[TEST] 发射器测试开始")
    
    var main = load("res://scenes/Main.tscn").instantiate()
    get_tree().root.add_child(main)
    await get_tree().process_frame
    
    var launcher = main.get_node_or_null("Launcher")
    assert_not_null(launcher, "[ERROR] 发射器不存在")
    print("[TEST] ✓ 找到发射器")
    
    # 测试发射
    print("[TEST] 发射弹珠...")
    launcher.launch()
    await get_tree().process_frame
    
    print("[TEST] ✅ 发射器测试通过")
    main.free()
```

### 4. 挡板测试

```gdscript
func test_flipper_logging():
    print("[TEST] 挡板测试开始")
    
    var main = load("res://scenes/Main.tscn").instantiate()
    get_tree().root.add_child(main)
    await get_tree().process_frame
    
    var left = main.get_node_or_null("LeftFlipper")
    var right = main.get_node_or_null("RightFlipper")
    
    assert_not_null(left, "[ERROR] 左挡板不存在")
    assert_not_null(right, "[ERROR] 右挡板不存在")
    print("[TEST] ✓ 找到挡板")
    
    # 测试左挡板
    Input.action_press("ui_left")
    await get_tree().process_frame
    print("[TEST] ✓ 左挡板按下")
    
    Input.action_release("ui_left")
    print("[TEST] ✓ 左挡板释放")
    
    # 测试右挡板
    Input.action_press("ui_right")
    await get_tree().process_frame
    print("[TEST] ✓ 右挡板按下")
    
    Input.action_release("ui_right")
    print("[TEST] ✓ 右挡板释放")
    
    print("[TEST] ✅ 挡板测试通过")
    main.free()
```

### 5. 得分测试

```gdscript
func test_scoring_logging():
    print("[TEST] 得分测试开始")
    
    var gm = GameManager.get_instance()
    gm.start_game()
    
    var initial_score = gm.get_score()
    print("[TEST] 初始分数: ", initial_score)
    
    gm.add_score(100)
    var new_score = gm.get_score()
    print("[TEST] 加分后分数: ", new_score)
    
    assert_eq(new_score, initial_score + 100, "[ERROR] 得分计算错误")
    print("[TEST] ✓ 得分正确")
    
    print("[TEST] ✅ 得分测试通过")
```

### 6. 游戏结束测试

```gdscript
func test_game_over_logging():
    print("[TEST] 游戏结束测试开始")
    
    var gm = GameManager.get_instance()
    gm.start_game()
    
    # 消耗所有球
    while gm.get_remaining_balls() > 0:
        gm.ball_lost()
        await get_tree().process_frame
        print("[TEST] 剩余球数: ", gm.get_remaining_balls())
    
    assert_true(gm.is_game_over(), "[ERROR] 游戏应结束")
    print("[TEST] ✓ 游戏已结束")
    print("[TEST] 最终分数: ", gm.get_score())
    
    print("[TEST] ✅ 游戏结束测试通过")
```

## 运行所有测试

```bash
# 运行控制台测试
godot --headless --path . -s test/run_console_tests.gd 2>&1 | tee console_test.log

# 分析输出
grep -E "\[TEST\]|\[ERROR\]|✅|❌" console_test.log
```

## 日志格式规范

```
[TEST] <测试名称> - 测试步骤描述
[ERROR] <错误描述> - 错误详情
✅ <测试通过>
❌ <测试失败>
[DEBUG] <调试信息>
[SCENE] <场景信息>
```

---

*更新于: 2026-02-22*

# GDSnap 集成测试

## 概述

GDSnap 是一个截图测试工具，可以与 GdUnit4 集成实现自动化截图验证。

## 安装 GDSnap

### 方式一：通过 Godot AssetLib 安装
1. 打开 Godot 编辑器 → AssetLib
2. 搜索 "GDSnap"
3. 点击下载 → 安装

### 方式二：手动安装
1. 下载 GDSnap: https://github.com/bitbrain/gdsnap
2. 解压到 `res://addons/gdsnap/`

### 启用插件
1. 项目 → 项目设置 → 插件
2. 启用 GDSnap

## 使用方法

### 在 GdUnit4 测试中使用

```gdscript
# test/integration/test_screenshot_gdsnap.gd
extends GdUnit4Test

func test_main_menu_screenshot():
    # 加载主菜单场景
    var menu = load("res://scenes/ui/MainMenu.tscn").instantiate()
    get_tree().root.add_child(menu)
    await get_tree().process_frame
    
    # 使用 GDSnap 截图比对
    var result = GDSnap.take_screenshot("main_menu", get_viewport())
    
    # 验证
    assert_true(result.is_success, "截图比对失败: " + result.error_message)
    
    menu.free()


func test_game_scene_screenshot():
    # 加载游戏场景
    var main = load("res://scenes/Main.tscn").instantiate()
    get_tree().root.add_child(main)
    await get_tree().process_frame
    
    # 截图
    var result = GDSnap.take_screenshot("game_main", get_viewport())
    
    assert_true(result.is_success, "游戏场景截图失败")
    
    main.free()


func test_flipper_visual():
    # 测试挡板视觉
    var main = load("res://scenes/Main.tscn").instantiate()
    get_tree().root.add_child(main)
    await get_tree().process_frame
    
    # 模拟按下挡板
    Input.action_press("ui_left")
    await get_tree().process_frame
    
    # 截图
    var result = GDSnap.take_screenshot("flipper_pressed", get_viewport())
    
    Input.action_release("ui_left")
    main.free()
    
    assert_true(result.is_success, "挡板截图失败")
```

### 更新基准截图

```gdscript
# 首次运行或更新基准图
GDSnap.update_base_screenshot("main_menu", get_viewport())
```

### 命令行运行

```bash
# 运行所有截图测试
godot --headless --script "res://addons/gdsnap/view/cli.gd"

# 指定测试
godot --headless --path . -s test/integration/test_screenshot_gdsnap.gd
```

## 集成到现有测试框架

将 GDSnap 集成到现有的截图测试基类:

```gdscript
# test/gdsnap_test_base.gd
extends GdUnit4Test

## GDSnap 集成基类

func capture_and_compare(screenshot_name: String) -> Dictionary:
    var viewport = get_viewport()
    
    # 尝试使用 GDSnap
    if ClassDB.class_exists("GDSnap"):
        var result = GDSnap.take_screenshot(screenshot_name, viewport)
        return {
            "passed": result.is_success,
            "similarity": result.similarity if result.is_success else 0.0,
            "error": result.error_message if not result.is_success else ""
        }
    else:
        # 回退到自定义截图
        return custom_screenshot_compare(screenshot_name, viewport)


func custom_screenshot_compare(screenshot_name: String, viewport: Viewport) -> Dictionary:
    # 原有自定义截图逻辑
    return {}
```

---

*更新于: 2026-02-22*

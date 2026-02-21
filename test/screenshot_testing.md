# Godot 截图验证测试方案

## 概述

类似Jest的视觉回归测试，为PI-PinBall实现截图验证功能。

## 核心思路

```
┌─────────────────────────────────────────────────────────────┐
│                    截图验证流程                              │
├─────────────────────────────────────────────────────────────┤
│  1. 基准截图 (Baseline)                                     │
│     → 首次运行时保存 "期望" 截图到 test/screenshots/baseline/│
│                                                              │
│  2. 对比截图 (Compare)                                      │
│     → 运行时截取当前画面，与基准图对比                        │
│                                                              │
│  3. 差异检测 (Diff)                                         │
│     → 生成差异图，显示像素差异位置                           │
│                                                              │
│  4. 判定结果 (Result)                                       │
│     → 差异率 < 阈值 → 通过                                  │
│     → 差异率 > 阈值 → 失败并生成报告                        │
└─────────────────────────────────────────────────────────────┘
```

## 文件结构

```
pi-pin-ball/
├── test/
│   ├── screenshot/
│   │   ├── baseline/          # 基准截图
│   │   │   ├── main_menu.png
│   │   │   ├── game_play.png
│   │   │   └── game_over.png
│   │   ├── current/            # 当前截图 (临时)
│   │   └── diff/               # 差异图 (测试失败时生成)
│   ├── screenshot_test.gd     # 截图测试基类
│   ├── test_main_menu.gd      # 主菜单截图测试
│   └── test_game_scenes.gd    # 游戏场景截图测试
└── screenshots/                # 游戏内截图保存目录
```

## 核心代码

### screenshot_test.gd - 截图测试基类

```gdscript
class_name ScreenshotTest
extends GutTest

## 截图验证测试基类
## 类似Jest的视觉回归测试

const BASELINE_DIR := "res://test/screenshot/baseline/"
const CURRENT_DIR := "res://test/screenshot/current/"
const DIFF_DIR := "res://test/screenshot/diff/"
const SIMILARITY_THRESHOLD := 0.95  # 95% 相似度阈值

var _viewport: SubViewport
var _viewport_texture: Image


func _init():
	# 确保目录存在
	DirAccess.make_dir_recursive_absolute(BASELINE_DIR)
	DirAccess.make_dir_recursive_absolute(CURRENT_DIR)
	DirAccess.make_dir_recursive_absolute(DIFF_DIR)


## 截取当前画面
func capture_screen(scene_name: String) -> Image:
	var viewport = get_viewport()
	var image = viewport.get_texture().get_image()
	
	# 保存当前截图
	var current_path = CURRENT_DIR + scene_name + ".png"
	image.save_png(current_path)
	
	return image


## 对比两张截图
func compare_screenshots(baseline_path: String, current_image: Image) -> Dictionary:
	var baseline_image = Image.new()
	var err = baseline_image.load(baseline_path)
	
	if err != OK:
		return {
			"passed": false,
			"error": "Failed to load baseline: " + baseline_path
		}
	
	# 调整大小以匹配
	if baseline_image.get_size() != current_image.get_size():
		current_image.resize(baseline_image.get_size().x, baseline_image.get_size().y)
	
	# 计算像素差异
	var width = baseline_image.get_size().x
	var height = baseline_image.get_size().y
	var total_pixels = width * height
	var diff_pixels = 0
	
	var diff_image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	
	for y in range(height):
		for x in range(width):
			var c1 = baseline_image.get_pixel(x, y)
			var c2 = current_image.get_pixel(x, y)
			
			if not _is_pixel_similar(c1, c2):
				diff_pixels += 1
				# 标记差异像素为红色
				diff_image.set_pixel(x, y, Color.RED)
			else:
				diff_image.set_pixel(x, y, Color(0, 0, 0, 0))
	
	var similarity = 1.0 - (float(diff_pixels) / float(total_pixels))
	
	# 保存差异图
	var diff_path = DIFF_DIR + "diff_" + Time.get_datetime_string().replace(":", "-") + ".png"
	diff_image.save_png(diff_path)
	
	return {
		"passed": similarity >= SIMILARITY_THRESHOLD,
		"similarity": similarity,
		"diff_pixels": diff_pixels,
		"total_pixels": total_pixels,
		"diff_path": diff_path
	}


func _is_pixel_similar(c1: Color, c2: Color, threshold: float = 0.1) -> bool:
	var dr = abs(c1.r - c2.r)
	var dg = abs(c1.g - c2.g)
	var db = abs(c1.b - c2.b)
	var da = abs(c1.a - c2.a)
	
	return (dr + dg + db + da) / 4.0 < threshold


## 更新基准截图
func update_baseline(scene_name: String) -> void:
	var current_path = CURRENT_DIR + scene_name + ".png"
	var baseline_path = BASELINE_DIR + scene_name + ".png"
	
	var img = Image.new()
	img.load(current_path)
	img.save_png(baseline_path)
	print("Updated baseline: " + baseline_path)
```

### test_main_menu.gd - 主菜单截图测试

```gdscript
class_name TestMainMenu
extends ScreenshotTest

func test_main_menu_looks_correct():
	# 加载主菜单场景
	var MainMenu = load("res://scenes/Main.tscn")
	var scene = MainMenu.instantiate()
	get_tree().root.add_child(scene)
	
	# 等待一帧让场景渲染
	await get_tree().process_frame
	
	# 截取主菜单
	var screenshot = capture_screen("main_menu")
	
	# 对比基准图
	var baseline_path = BASELINE_DIR + "main_menu.png"
	var result = compare_screenshots(baseline_path, screenshot)
	
	# 清理
	scene.free()
	
	# 断言
	assert_true(result.passed, "Main menu screenshot mismatch: " + str(result))


func test_main_menu_buttons_visible():
	# 加载主菜单
	var MainMenu = load("res://scenes/Main.tscn")
	var scene = MainMenu.instantiate()
	get_tree().root.add_child(scene)
	
	await get_tree().process_frame
	
	# 截取并检查按钮区域
	var screenshot = capture_screen("main_menu_buttons")
	var result = compare_screenshots(BASELINE_DIR + "main_menu_buttons.png", screenshot)
	
	scene.free()
	assert_true(result.passed, "Buttons not visible or changed")
```

## CI/CD 集成

### GitHub Actions 工作流

```yaml
name: Screenshot Tests

on: [push, pull_request]

jobs:
  screenshot-test:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Godot
        uses: heroiclabs/godot-action@v1
        with:
          godot-version: '4.5.1'
      
      - name: Run Screenshot Tests
        run: |
          godot --headless --path . -s test/run_screenshot_tests.gd
      
      - name: Upload Baseline Screenshots
        uses: actions/upload-artifact@v4
        if: github.event_name == 'push'
        with:
          name: baseline-screenshots
          path: test/screenshot/baseline/
      
      - name: Upload Diff Screenshots
        uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: screenshot-diff
          path: test/screenshot/diff/
```

## 使用方法

### 运行截图测试

```bash
# 运行所有截图测试
godot --headless --path . -s test/run_screenshot_tests.gd

# 更新基准截图 (谨慎使用!)
godot --headless --path . -s test/update_baseline.gd
```

### 在OpenClaw中集成

使用browser工具控制Godot:
1. 启动Godot并打开项目
2. 运行游戏到指定场景
3. 截取屏幕画面
4. 调用截图测试进行对比

## 对比Jest的视觉测试

| Jest (JavaScript) | Godot (GDScript) |
|-------------------|------------------|
| jest-image-snapshot | ScreenshotTest (我们的方案) |
| toMatchImageSnapshot | compare_screenshots() |
| updateSnapshot | update_baseline() |
| pixelmatch | 自定义像素对比算法 |

## 优势

1. **自动化** - 无需人工检查UI变化
2. **精确** - 像素级差异检测
3. **可追溯** - 保存差异图便于调试
4. **CI集成** - 自动化的视觉回归测试

---

*创建时间: 2026-02-21*

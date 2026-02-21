# Screenshot Test Base Class
# 类似Jest的视觉回归测试

extends GutTest

## 截图验证测试基类
## Similar to Jest's visual regression testing

const BASELINE_DIR := "res://test/screenshot/baseline/"
const CURRENT_DIR := "res://test/screenshot/current/"
const DIFF_DIR := "res://test/screenshot/diff/"
const SIMILARITY_THRESHOLD := 0.95  # 95% 相似度阈值

var _test_mode := false  # true = 更新基准图


func _init():
	_init_base_dirs()


func _init_base_dirs() -> void:
	var dirs = [BASELINE_DIR, CURRENT_DIR, DIFF_DIR]
	for dir in dirs:
		var da = DirAccess.open("res://")
		if da:
			da.make_dir_recursive(dir)


## 截取当前画面
func capture_screen(scene_name: String) -> Image:
	var viewport = get_viewport()
	await get_tree().process_frame  # 等待渲染
	var image = viewport.get_texture().get_image()
	
	# 保存当前截图
	var current_path = CURRENT_DIR + scene_name + ".png"
	image.save_png(current_path)
	
	return image


## 对比两张截图
func compare_screenshots(baseline_name: String, current_image: Image) -> Dictionary:
	var baseline_path = BASELINE_DIR + baseline_name + ".png"
	
	# 检查基准图是否存在
	if not FileAccess.file_exists(baseline_path):
		if _test_mode:
			# 更新模式：保存当前图作为基准
			current_image.save_png(baseline_path)
			return {"passed": true, "mode": "baseline_created"}
		else:
			return {"passed": false, "error": "No baseline: " + baseline_path}
	
	var baseline_image = Image.new()
	var err = baseline_image.load(baseline_path)
	
	if err != OK:
		return {"passed": false, "error": "Failed to load baseline"}
	
	# 调整大小以匹配
	if baseline_image.get_size() != current_image.get_size():
		current_image.resize(baseline_image.get_size().x, baseline_image.get_size().y)
	
	# 计算像素差异
	var result = _compute_pixel_diff(baseline_image, current_image)
	
	# 保存差异图
	if not result.passed:
		var diff_path = DIFF_DIR + "diff_" + baseline_name + ".png"
		result.diff_image.save_png(diff_path)
		result.diff_path = diff_path
	
	return result


func _compute_pixel_diff(baseline: Image, current: Image) -> Dictionary:
	var width = baseline.get_size().x
	var height = baseline.get_size().y
	var total_pixels = width * height
	var diff_pixels = 0
	
	var diff_image = Image.create(width, height, false, Image.FORMAT_RGBA8)
	
	for y in range(height):
		for x in range(width):
			var c1 = baseline.get_pixel(x, y)
			var c2 = current.get_pixel(x, y)
			
			if not _is_pixel_similar(c1, c2):
				diff_pixels += 1
				diff_image.set_pixel(x, y, Color(1, 0, 0, 0.5))  # 红色标记
			else:
				diff_image.set_pixel(x, y, Color(0, 0, 0, 0))
	
	var similarity = 1.0 - (float(diff_pixels) / float(total_pixels))
	
	return {
		"passed": similarity >= SIMILARITY_THRESHOLD,
		"similarity": similarity,
		"diff_pixels": diff_pixels,
		"total_pixels": total_pixels,
		"diff_image": diff_image
	}


func _is_pixel_similar(c1: Color, c2: Color, threshold: float = 0.1) -> bool:
	var dr = abs(c1.r - c2.r)
	var dg = abs(c1.g - c2.g)
	var db = abs(c1.b - c2.b)
	var da = abs(c1.a - c2.a)
	return (dr + dg + db + da) / 4.0 < threshold


## 更新基准截图
func update_baseline(scene_name: String) -> void:
	_test_mode = true
	var current_path = CURRENT_DIR + scene_name + ".png"
	var baseline_path = BASELINE_DIR + scene_name + ".png"
	
	if FileAccess.file_exists(current_path):
		var img = Image.new()
		img.load(current_path)
		img.save_png(baseline_path)
		print("Updated baseline: " + baseline_path)
	_test_mode = false


func get_screenshot_path(scene_name: String) -> String:
	return CURRENT_DIR + scene_name + ".png"

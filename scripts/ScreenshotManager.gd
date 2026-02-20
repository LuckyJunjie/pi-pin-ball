extends Node
class_name ScreenshotManager

## ScreenshotManager.gd - 截图管理器
## 处理游戏截图功能

static var instance: ScreenshotManager

## 截图保存目录
var screenshot_dir: String = "C:/Users/panju/.openclaw/workspace/pi-pin-ball/screenshots"

func _ready() -> void:
	instance = self
	# 确保截图目录存在
	_dirty_check_directory()
	print("ScreenshotManager: 初始化完成")

func _dirty_check_directory() -> void:
	# 检查并创建截图目录
	var dir = DirAccess.open(screenshot_dir)
	if dir == null:
		# 创建目录需要使用 DirAccess 的实例
		var make_dir = DirAccess.open(".")
		if make_dir:
			var err = make_dir.make_dir_recursive(screenshot_dir)
			if err == OK:
				print("ScreenshotManager: 创建截图目录 - ", screenshot_dir)
			else:
				push_error("ScreenshotManager: 创建目录失败 - ", err)
	else:
		# 目录已存在，关闭 dir
		dir = null  # Will be freed

## 截取屏幕并保存
static func capture_screenshot(filename: String = "") -> String:
	if filename.is_empty():
		# 使用时间戳作为默认文件名
		var timestamp = Time.get_datetime_string_from_system().replace(":", "-")
		filename = "screenshot_" + timestamp + ".png"
	
	var filepath = instance.screenshot_dir + "/" + filename
	
	# 获取视口图像
	var img = instance.get_viewport().get_texture().get_image()
	
	# 保存图像
	var error = img.save_png(filepath)
	
	if error == OK:
		print("ScreenshotManager: 截图已保存 - ", filepath)
		return filepath
	else:
		push_error("ScreenshotManager: 截图保存失败 - ", error)
		return ""

## 快捷截图（带默认文件名）
func take_screenshot() -> String:
	return capture_screenshot()

## 带提示的截图
func capture_with_feedback() -> String:
	var filepath = take_screenshot()
	if not filepath.is_empty():
		# 可以在这里添加截图成功的UI反馈
		print("截图成功: ", filepath)
	return filepath

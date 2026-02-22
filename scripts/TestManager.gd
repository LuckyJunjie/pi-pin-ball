extends Node
class_name TestManager

## TestManager.gd - 测试模式管理器
## 用于自动化测试，支持命令行参数控制

## 测试模式标志
var test_mode: bool = false
var test_scene: String = ""
var headless: bool = false

## 测试配置
var auto_start_game: bool = true
var skip_menu: bool = true

func _ready() -> void:
	# 解析启动参数
	_parse_command_line_args()
	
	if test_mode:
		print("[TestManager] 测试模式已启用!")
		print("  test_scene: ", test_scene)
		print("  headless: ", headless)

func _parse_command_line_args() -> void:
	var args = OS.get_cmdline_args()
	
	for arg in args:
		match arg:
			"--testmode":
				test_mode = true
			"--testmode-auto":
				test_mode = true
				auto_start_game = true
				skip_menu = true
			"--headless":
				headless = true
			_:
				if arg.begins_with("--testscene="):
					test_scene = arg.replace("--testscene=", "")
				elif arg.begins_with("--scene="):
					test_scene = arg.replace("--scene=", "")

## 获取测试场景路径
func get_test_scene_path() -> String:
	if test_scene:
		# 尝试多种路径格式
		if test_scene.begins_with("res://"):
			return test_scene
		elif test_scene.begins_with("scenes/"):
			return "res://" + test_scene
		else:
			return "res://scenes/" + test_scene + ".tscn"
	
	# 默认返回Main场景
	return "res://scenes/Main.tscn"

## 获取主菜单场景路径
func get_menu_scene_path() -> String:
	return "res://scenes/ui/MainMenu.tscn"

## 是否应跳过菜单
func should_skip_menu() -> bool:
	return test_mode and skip_menu

## 是否应自动开始游戏
func should_auto_start_game() -> bool:
	return test_mode and auto_start_game

## 静态方法: 获取实例
static func get_instance() -> TestManager:
	var tm = get_tree().root.get_node_or_null("/root/TestManager")
	if not tm:
		# 如果不存在，创建一个临时实例
		tm = TestManager.new()
	return tm

## 辅助: 检查是否在测试模式
static func is_test_mode() -> bool:
	var tm = get_instance()
	return tm and tm.test_mode

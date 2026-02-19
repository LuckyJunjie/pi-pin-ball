extends Node

## LevelManager.gd - 关卡管理系统
## 管理游戏关卡的加载、切换和难度

signal level_started(level: int)
signal level_completed(level: int)
signal level_failed(level: int)

## 当前关卡
var current_level: int = 1
var max_level: int = 5

## 关卡配置
var level_configs: Dictionary = {
	1: {
		"name": "Android Acres",
		"difficulty": 1.0,
		"ball_speed": 500.0,
		"flipper_speed": 8.0,
		"target_score": 1000,
		"time_limit": 120
	},
	2: {
		"name": "Flutter Forest", 
		"difficulty": 1.5,
		"ball_speed": 600.0,
		"flipper_speed": 9.0,
		"target_score": 2500,
		"time_limit": 120
	},
	3: {
		"name": "Dart Canyon",
		"difficulty": 2.0,
		"ball_speed": 700.0,
		"flipper_speed": 10.0,
		"target_score": 5000,
		"time_limit": 150
	},
	4: {
		"name": "Firebase Falls",
		"difficulty": 2.5,
		"ball_speed": 800.0,
		"flipper_speed": 11.0,
		"target_score": 10000,
		"time_limit": 180
	},
	5: {
		"name": "Google Gardens",
		"difficulty": 3.0,
		"ball_speed": 900.0,
		"flipper_speed": 12.0,
		"target_score": 20000,
		"time_limit": 200
	}
}

## 主题区域位置（每个关卡不同的障碍物布局）
var theme_areas: Dictionary = {
	1: {  # Android Acres
		"top_left": Vector2(200, 150),
		"top_right": Vector2(900, 150),
		"middle": Vector2(550, 250)
	},
	2: {  # Flutter Forest
		"top_left": Vector2(180, 130),
		"top_right": Vector2(920, 130),
		"middle": Vector2(550, 280),
		"bottom": Vector2(550, 400)
	}
}

func _ready() -> void:
	print("LevelManager: 初始化完成")

## 获取当前关卡配置
func get_current_level_config() -> Dictionary:
	return level_configs.get(current_level, level_configs[1])

## 获取关卡名称
func get_level_name() -> String:
	var config = get_current_level_config()
	return config.get("name", "Unknown")

## 开始指定关卡
func start_level(level: int) -> void:
	if level < 1 or level > max_level:
		push_error("LevelManager: 无效的关卡号 ", level)
		return
	
	current_level = level
	print("LevelManager: 开始关卡 ", current_level, " - ", get_level_name())
	level_started.emit(current_level)
	
	# 应用关卡设置
	_apply_level_settings()

## 应用关卡难度设置
func _apply_level_settings() -> void:
	var config = get_current_level_config()
	
	# 这里可以设置游戏难度参数
	# 比如球速、挡板速度等
	print("LevelManager: 应用难度 ", config["difficulty"])

## 完成当前关卡
func complete_level() -> void:
	print("LevelManager: 关卡 ", current_level, " 完成!")
	level_completed.emit(current_level)

## 失败当前关卡
func fail_level() -> void:
	print("LevelManager: 关卡 ", current_level, " 失败!")
	level_failed.emit(current_level)

## 下一关
func next_level() -> void:
	if current_level < max_level:
		start_level(current_level + 1)
	else:
		print("LevelManager: 所有关卡已完成!")
		# 游戏通关

## 重置到第一关
func reset_game() -> void:
	current_level = 1
	start_level(1)

## 获取进度百分比
func get_progress() -> float:
	return float(current_level) / float(max_level)

## 检查是否是最后一关
func is_last_level() -> bool:
	return current_level >= max_level

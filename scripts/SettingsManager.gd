extends Node

## SettingsManager.gd - 设置管理系统
## 管理游戏设置：音效、显示、控制等

## 设置数据
var settings: Dictionary = {
	# 音效设置
	"sound": {
		"sfx_volume": 0.8,
		"music_volume": 0.6,
		"master_volume": 1.0
	},
	# 显示设置
	"display": {
		"fullscreen": false,
		"vsync": true,
		"show_fps": false,
		"quality": "high"  # low, medium, high
	},
	# 控制设置
	"controls": {
		"left_flipper_key": KEY_A,
		"right_flipper_key": KEY_SPACE,
		"launch_key": KEY_SPACE,
		"pause_key": KEY_ESCAPE,
		"touch_controls": false
	},
	# 游戏设置
	"game": {
		"difficulty": "normal",  # easy, normal, hard
		"ball_count": 3,
		"show_tutorial": true,
		"auto_save": true
	}
}

## 设置文件路径
var settings_file_path: String = "user://settings.cfg"

func _ready() -> void:
	load_settings()
	print("SettingsManager: 初始化完成")

## 保存设置到文件
func save_settings() -> void:
	var config = ConfigFile.new()
	
	for section in settings.keys():
		for key in settings[section].keys():
			config.set_value(section, key, settings[section][key])
	
	var err = config.save(settings_file_path)
	if err == OK:
		print("SettingsManager: 设置已保存")
	else:
		push_error("SettingsManager: 保存设置失败 - ", err)

## 从文件加载设置
func load_settings() -> void:
	var config = ConfigFile.new()
	var err = config.load(settings_file_path)
	
	if err == OK:
		for section in settings.keys():
			for key in settings[section].keys():
				if config.has_section_key(section, key):
					settings[section][key] = config.get_value(section, key)
		print("SettingsManager: 设置已加载")
	else:
		print("SettingsManager: 使用默认设置")

## 获取设置值
func get_setting(section: String, key: String, default = null):
	if settings.has(section) and settings[section].has(key):
		return settings[section][key]
	return default

## 设置值
func set_setting(section: String, key: String, value) -> void:
	if settings.has(section):
		settings[section][key] = value
		print("SettingsManager: 设置 ", section, ".", key, " = ", value)

## 音效设置
func get_sfx_volume() -> float:
	return settings["sound"]["sfx_volume"]

func set_sfx_volume(volume: float) -> void:
	settings["sound"]["sfx_volume"] = clamp(volume, 0.0, 1.0)

func get_music_volume() -> float:
	return settings["sound"]["music_volume"]

func set_music_volume(volume: float) -> void:
	settings["sound"]["music_volume"] = clamp(volume, 0.0, 1.0)

## 显示设置
func is_fullscreen() -> bool:
	return settings["display"]["fullscreen"]

func set_fullscreen(enabled: bool) -> void:
	settings["display"]["fullscreen"] = enabled

func get_quality() -> String:
	return settings["display"]["quality"]

func set_quality(quality: String) -> void:
	settings["display"]["quality"] = quality

## 游戏设置
func get_difficulty() -> String:
	return settings["game"]["difficulty"]

func set_difficulty(difficulty: String) -> void:
	settings["game"]["difficulty"] = difficulty

func get_ball_count() -> int:
	return settings["game"]["ball_count"]

func set_ball_count(count: int) -> void:
	settings["game"]["ball_count"] = clamp(count, 1, 10)

## 重置为默认设置
func reset_to_defaults() -> void:
	settings = {
		"sound": {"sfx_volume": 0.8, "music_volume": 0.6, "master_volume": 1.0},
		"display": {"fullscreen": false, "vsync": true, "show_fps": false, "quality": "high"},
		"controls": {"left_flipper_key": KEY_A, "right_flipper_key": KEY_SPACE, "pause_key": KEY_EDULE},
		"game": {"difficulty": "normal", "ball_count": 3, "show_tutorial": true, "auto_save": true}
	}
	print("SettingsManager: 已重置为默认设置")

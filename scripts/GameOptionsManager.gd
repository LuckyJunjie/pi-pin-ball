extends Node

## GameOptionsManager.gd - 游戏选项管理器
## 管理游戏难度、模式等选项

enum GameMode {
	CLASSIC,    # 经典模式
	ZEN,        # 禅模式（无限球）
	CHALLENGE,  # 挑战模式（限时）
	TIME_ATTACK # 计时攻击
}

enum Difficulty {
	EASY,
	NORMAL,
	HARD,
	EXPERT
}

var current_mode: GameMode = GameMode.CLASSIC
var current_difficulty: Difficulty = Difficulty.NORMAL

## 模式设置
var mode_settings: Dictionary = {
	GameMode.CLASSIC: {
		"name": "经典模式",
		"description": "标准弹球玩法，3个球，目标是获得最高分",
		"ball_count": 3,
		"time_limit": 0,
		"lives": true
	},
	GameMode.ZEN: {
		"name": "禅模式",
		"description": "无限球，放松练习",
		"ball_count": -1,  # -1 表示无限
		"time_limit": 0,
		"lives": false
	},
	GameMode.CHALLENGE: {
		"name": "挑战模式",
		"description": "限时挑战，60秒内获得最高分",
		"ball_count": 3,
		"time_limit": 60,
		"lives": true
	},
	GameMode.TIME_ATTACK: {
		"name": "计时攻击",
		"description": "3分钟内尽可能多得分",
		"ball_count": 3,
		"time_limit": 180,
		"lives": true
	}
}

## 难度设置
var difficulty_settings: Dictionary = {
	Difficulty.EASY: {
		"name": "简单",
		"ball_speed_mult": 0.8,
		"flipper_speed_mult": 0.8,
		"score_mult": 1.5,
		"gravity_mult": 0.9
	},
	Difficulty.NORMAL: {
		"name": "普通",
		"ball_speed_mult": 1.0,
		"flipper_speed_mult": 1.0,
		"score_mult": 1.0,
		"gravity_mult": 1.0
	},
	Difficulty.HARD: {
		"name": "困难",
		"ball_speed_mult": 1.2,
		"flipper_speed_mult": 1.2,
		"score_mult": 0.8,
		"gravity_mult": 1.1
	},
	Difficulty.EXPERT: {
		"name": "专家",
		"ball_speed_mult": 1.5,
		"flipper_speed_mult": 1.5,
		"score_mult": 0.5,
		"gravity_mult": 1.2
	}
}

func _ready() -> void:
	_load_options()

func _load_options() -> void:
	# 从设置文件加载
	var settings_file = "user://game_options.dat"
	if FileAccess.file_exists(settings_file):
		var file = FileAccess.open(settings_file, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			if parse_result == OK:
				var data = json.get_data()
				current_mode = data.get("mode", GameMode.CLASSIC)
				current_difficulty = data.get("difficulty", Difficulty.NORMAL)
			file.close()

func _save_options() -> void:
	var settings_file = "user://game_options.dat"
	var file = FileAccess.open(settings_file, FileAccess.WRITE)
	if file:
		var data = {
			"mode": current_mode,
			"difficulty": current_difficulty
		}
		file.store_string(JSON.stringify(data))
		file.close()

## 获取当前设置
func get_current_mode() -> GameMode:
	return current_mode

func get_current_difficulty() -> Difficulty:
	return current_difficulty

func get_mode_settings() -> Dictionary:
	return mode_settings.get(current_mode, mode_settings[GameMode.CLASSIC])

func get_difficulty_settings() -> Dictionary:
	return difficulty_settings.get(current_difficulty, difficulty_settings[Difficulty.NORMAL])

## 设置模式和难度
func set_mode(mode: GameMode) -> void:
	current_mode = mode
	_save_options()

func set_difficulty(difficulty: Difficulty) -> void:
	current_difficulty = difficulty
	_save_options()

## 获取游戏参数
func get_ball_count() -> int:
	var mode = get_mode_settings()
	return mode.get("ball_count", 3)

func get_time_limit() -> int:
	var mode = get_mode_settings()
	return mode.get("time_limit", 0)

func get_ball_speed_mult() -> float:
	var diff = get_difficulty_settings()
	return diff.get("ball_speed_mult", 1.0)

func get_flipper_speed_mult() -> float:
	var diff = get_difficulty_settings()
	return diff.get("flipper_speed_mult", 1.0)

func get_score_mult() -> float:
	var diff = get_difficulty_settings()
	return diff.get("score_mult", 1.0)

func has_lives() -> bool:
	var mode = get_mode_settings()
	return mode.get("lives", true)

func is_time_limited() -> bool:
	return get_time_limit() > 0

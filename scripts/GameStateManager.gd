extends Node

## GameStateManager.gd - 游戏状态管理器
## 管理游戏进度、保存和成就系统

const SAVE_FILE_PATH = "user://game_save.dat"

## 游戏进度数据
var game_data: Dictionary = {
	"high_score": 0,
	"total_play_time": 0,
	"levels_unlocked": 1,
	"characters_unlocked": ["default"],
	"achievements": [],
	"statistics": {
		"total_games": 0,
		"total_score": 0,
		"best_combo": 0,
		"balls_lost": 0
	}
}

func _ready() -> void:
	load_game()

## 保存游戏数据
func save_game() -> void:
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(game_data)
		file.store_string(json_string)
		file.close()
		print("GameStateManager: 游戏已保存")

## 加载游戏数据
func load_game() -> void:
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			if parse_result == OK:
				game_data = json.get_data()
			file.close()
			print("GameStateManager: 游戏已加载")

## 成就系统
var achievements: Dictionary = {
	"first_game": {"name": "初学者", "description": "完成第一局游戏", "unlocked": false},
	"score_1000": {"name": "千里挑一", "description": "单局得分超过1000", "unlocked": false},
	"score_5000": {"name": "万分达人", "description": "单局得分超过5000", "unlocked": false},
	"score_10000": {"name": "万分大师", "description": "单局得分超过10000", "unlocked": false},
	"combo_5": {"name": "五连击", "description": "达成5连击", "unlocked": false},
	"combo_10": {"name": "十连击", "description": "达成10连击", "unlocked": false},
	"level_2": {"name": "进阶玩家", "description": "解锁第2关", "unlocked": false},
	"level_3": {"name": "高手", "description": "解锁第3关", "unlocked": false},
	"all_levels": {"name": "关卡大师", "description": "解锁所有关卡", "unlocked": false},
	"play_10_games": {"name": "老玩家", "description": "完成10局游戏", "unlocked": false}
}

## 检查并解锁成就
func check_achievement(achievement_id: String) -> bool:
	if achievements.has(achievement_id) and not achievements[achievement_id]["unlocked"]:
		achievements[achievement_id]["unlocked"] = true
		game_data["achievements"].append(achievement_id)
		save_game()
		print("GameStateManager: 成就解锁 - ", achievements[achievement_id]["name"])
		return true
	return false

## 更新最高分
func update_high_score(score: int) -> void:
	if score > game_data["high_score"]:
		game_data["high_score"] = score
		check_achievement("score_1000")
		if score >= 5000:
			check_achievement("score_5000")
		if score >= 10000:
			check_achievement("score_10000")
		save_game()

## 解锁关卡
func unlock_level(level: int) -> void:
	if level > game_data["levels_unlocked"]:
		game_data["levels_unlocked"] = level
		if level >= 2:
			check_achievement("level_2")
		if level >= 3:
			check_achievement("level_3")
		if level >= 5:
			check_achievement("all_levels")
		save_game()

## 更新统计
func update_statistics(key: String, value: int) -> void:
	if game_data["statistics"].has(key):
		game_data["statistics"][key] += value
		save_game()

## 获取数据
func get_high_score() -> int:
	return game_data.get("high_score", 0)

func get_levels_unlocked() -> int:
	return game_data.get("levels_unlocked", 1)

func get_unlocked_characters() -> Array:
	return game_data.get("characters_unlocked", ["default"])

func get_achievements() -> Dictionary:
	return achievements

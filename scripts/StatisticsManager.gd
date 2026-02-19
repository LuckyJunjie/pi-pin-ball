extends Node

## StatisticsManager.gd - 游戏统计数据管理器
## 追踪和分析玩家游戏数据

var statistics: Dictionary = {
	"total_games_played": 0,
	"total_time_played": 0.0,
	"total_score": 0,
	"highest_score": 0,
	"average_score": 0,
	"highest_combo": 0,
	"total_balls_lost": 0,
	"total_targets_hit": 0,
	"levels_completed": 0,
	"achievements_unlocked": 0,
	"favorite_character": "default",
	"most_played_level": 1,
	"session_stats": {
		"current_session_games": 0,
		"current_session_time": 0.0,
		"current_session_score": 0
	}
}

const STATS_FILE = "user://statistics.dat"

func _ready() -> void:
	_load_statistics()

func _load_statistics() -> void:
	if FileAccess.file_exists(STATS_FILE):
		var file = FileAccess.open(STATS_FILE, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			if parse_result == OK:
				statistics = json.get_data()
			file.close()

func _save_statistics() -> void:
	var file = FileAccess.open(STATS_FILE, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(statistics)
		file.store_string(json_string)
		file.close()

## 更新统计
func record_game(score: int, time: float, combo: int, balls_lost: int, level: int) -> void:
	statistics["total_games_played"] += 1
	statistics["total_time_played"] += time
	statistics["total_score"] += score
	statistics["total_balls_lost"] += balls_lost
	
	if score > statistics["highest_score"]:
		statistics["highest_score"] = score
	
	if combo > statistics["highest_combo"]:
		statistics["highest_combo"] = combo
	
	# 计算平均分
	statistics["average_score"] = statistics["total_score"] / statistics["total_games_played"]
	
	# 更新最常玩关卡
	if statistics["most_played_level"] == level:
		pass
	else:
		statistics["most_played_level"] = level
	
	_save_statistics()
	print("StatisticsManager: 游戏数据已记录")

## 记录击中目标
func record_target_hit() -> void:
	statistics["total_targets_hit"] += 1
	_save_statistics()

## 记录关卡完成
func record_level_completed(level: int) -> void:
	statistics["levels_completed"] += 1
	_save_statistics()

## 记录成就解锁
func record_achievement_unlocked() -> void:
	statistics["achievements_unlocked"] += 1
	_save_statistics()

## 获取统计
func get_statistics() -> Dictionary:
	return statistics

func get_highest_score() -> int:
	return statistics.get("highest_score", 0)

func get_average_score() -> int:
	return statistics.get("average_score", 0)

func get_total_games() -> int:
	return statistics.get("total_games_played", 0)

func get_total_play_time() -> float:
	return statistics.get("total_time_played", 0.0)

func format_play_time() -> String:
	var total_seconds = int(get_total_play_time())
	var hours = total_seconds / 3600
	var minutes = (total_seconds % 3600) / 60
	var seconds = total_seconds % 60
	
	if hours > 0:
		return "%d小时%d分钟" % [hours, minutes]
	elif minutes > 0:
		return "%d分钟%d秒" % [minutes, seconds]
	else:
		return "%d秒" % seconds

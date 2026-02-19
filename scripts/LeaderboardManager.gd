extends Node

## LeaderboardManager.gd - 排行榜管理器
## 管理本地排行榜数据

const LEADERBOARD_FILE = "user://leaderboard.dat"

var leaderboard_data: Array[Dictionary] = []

func _ready() -> void:
	_load_leaderboard()

func _load_leaderboard() -> void:
	if FileAccess.file_exists(LEADERBOARD_FILE):
		var file = FileAccess.open(LEADERBOARD_FILE, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			if parse_result == OK:
				leaderboard_data = json.get_data()
			file.close()
	else:
		# 初始化默认排行榜
		leaderboard_data = [
			{"name": "Player1", "score": 10000},
			{"name": "Player2", "score": 8000},
			{"name": "Player3", "score": 6000},
			{"name": "Player4", "score": 4000},
			{"name": "Player5", "score": 2000}
		]
		_save_leaderboard()

func _save_leaderboard() -> void:
	var file = FileAccess.open(LEADERBOARD_FILE, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(leaderboard_data)
		file.store_string(json_string)
		file.close()

## 检查是否上榜
func is_high_score(score: int) -> bool:
	if leaderboard_data.size() < 10:
		return true
	return score > leaderboard_data[leaderboard_data.size() - 1]["score"]

## 添加新分数
func add_score(player_name: String, score: int) -> bool:
	if not is_high_score(score):
		return false
	
	# 添加新分数
	leaderboard_data.append({
		"name": player_name,
		"score": score,
		"date": Time.get_datetime_string_from_system()
	})
	
	# 按分数排序
	leaderboard_data.sort_custom(func(a, b): return a["score"] > b["score"])
	
	# 只保留前10名
	if leaderboard_data.size() > 10:
		leaderboard_data.resize(10)
	
	_save_leaderboard()
	return true

## 获取排行榜
func get_leaderboard() -> Array[Dictionary]:
	return leaderboard_data

## 获取排名
func get_rank(score: int) -> int:
	for i in range(leaderboard_data.size()):
		if score >= leaderboard_data[i]["score"]:
			return i + 1
	return leaderboard_data.size() + 1

## 清除排行榜
func clear_leaderboard() -> void:
	leaderboard_data.clear()
	_save_leaderboard()

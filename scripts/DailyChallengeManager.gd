extends Node

## DailyChallengeManager.gd - 每日挑战系统
## 管理每日挑战任务和奖励

var daily_challenge: Dictionary = {}
var challenge_completed: bool = false

const CHALLENGE_FILE = "user://daily_challenge.dat"

func _ready() -> void:
	_load_daily_challenge()

func _load_daily_challenge() -> void:
	# 获取今天的日期
	var today = Time.get_datetime_string_from_system().split("T")[0]
	
	# 检查本地保存的挑战是否是今天的
	if FileAccess.file_exists(CHALLENGE_FILE):
		var file = FileAccess.open(CHALLENGE_FILE, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			var json = JSON.new()
			var parse_result = json.parse(json_string)
			if parse_result == OK:
				var saved_data = json.get_data()
				if saved_data.get("date") == today:
					daily_challenge = saved_data
					challenge_completed = saved_data.get("completed", false)
					print("DailyChallenge: 今日挑战已加载")
					return
			file.close()
	
	# 生成新的每日挑战
	_generate_new_challenge(today)

func _generate_new_challenge(date: String) -> void:
	var challenges = [
		{
			"id": "score_3000",
			"name": "得分达人",
			"description": "单局得分达到3000",
			"type": "score",
			"target": 3000,
			"reward": 100
		},
		{
			"id": "combo_5",
			"name": "连击达人",
			"description": "达成5连击",
			"type": "combo",
			"target": 5,
			"reward": 50
		},
		{
			"id": "survive_60",
			"name": "坚持就是胜利",
			"description": "单局存活60秒",
			"type": "time",
			"target": 60,
			"reward": 80
		},
		{
			"id": "hit_20",
			"name": "击中目标",
			"description": "击中20个得分区域",
			"type": "hits",
			"target": 20,
			"reward": 60
		},
		{
			"id": "no_lose_ball",
			"name": "完美防守",
			"description": "一局不失球",
			"type": "perfect",
			"target": 1,
			"reward": 150
		}
	]
	
	# 随机选择一个挑战
	daily_challenge = {
		"date": date,
		"challenge": challenges.pick_random(),
		"completed": false,
		"claimed": false
	}
	
	_save_daily_challenge()
	print("DailyChallenge: 新挑战已生成 - ", daily_challenge["challenge"]["name"])

func _save_daily_challenge() -> void:
	var file = FileAccess.open(CHALLENGE_FILE, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(daily_challenge)
		file.store_string(json_string)
		file.close()

## 检查挑战进度
func check_progress(progress_type: String, value: int) -> void:
	if daily_challenge.get("completed", false):
		return
	
	var challenge = daily_challenge.get("challenge", {})
	if challenge.get("type") == progress_type:
		if value >= challenge.get("target", 0):
			complete_challenge()

## 完成挑战
func complete_challenge() -> void:
	daily_challenge["completed"] = true
	_save_daily_challenge()
	print("DailyChallenge: 挑战完成! - ", daily_challenge["challenge"]["name"])

## 领取奖励
func claim_reward() -> int:
	if not daily_challenge.get("completed", false):
		return 0
	
	if daily_challenge.get("claimed", false):
		return 0
	
	daily_challenge["claimed"] = true
	_save_daily_challenge()
	
	var reward = daily_challenge.get("challenge", {}).get("reward", 0)
	print("DailyChallenge: 奖励已领取 - ", reward)
	return reward

## 获取挑战信息
func get_challenge() -> Dictionary:
	return daily_challenge.get("challenge", {})

func is_completed() -> bool:
	return daily_challenge.get("completed", false)

func is_claimed() -> bool:
	return daily_challenge.get("claimed", false)

func get_progress(current_value: int) -> float:
	var target = daily_challenge.get("challenge", {}).get("target", 1)
	return float(current_value) / float(target)

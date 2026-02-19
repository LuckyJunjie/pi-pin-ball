extends Control

## StatisticsUI.gd - 游戏统计界面
## 显示玩家游戏统计数据

signal back_pressed()

var statistics: Dictionary = {}

@onready var grid: GridContainer = $StatsGrid

func _ready() -> void:
	_load_statistics()
	_create_statistics_display()
	$BackButton.pressed.connect(_on_back_pressed)

func _load_statistics() -> void:
	var stats_manager = get_node_or_null("/root/StatisticsManager")
	if stats_manager and stats_manager.has_method("get_statistics"):
		statistics = stats_manager.get_statistics()
	else:
		statistics = {
			"total_games_played": 0,
			"total_time_played": 0.0,
			"highest_score": 0,
			"average_score": 0,
			"highest_combo": 0,
			"total_balls_lost": 0,
			"total_targets_hit": 0,
			"levels_completed": 0
		}

func _create_statistics_display() -> void:
	var stats_items = [
		{"label": "🎮 总游戏次数", "value": str(statistics.get("total_games_played", 0))},
		{"label": "⏱️ 总游戏时间", "value": _format_time(statistics.get("total_time_played", 0.0))},
		{"label": "🏆 最高分", "value": str(statistics.get("highest_score", 0))},
		{"label": "📊 平均分", "value": str(statistics.get("average_score", 0))},
		{"label": "🔥 最高连击", "value": str(statistics.get("highest_combo", 0))},
		{"label": "🎱 累计失球", "value": str(statistics.get("total_balls_lost", 0))},
		{"label": "🎯 累计击中", "value": str(statistics.get("total_targets_hit", 0))},
		{"label": "✅ 完成关卡", "value": str(statistics.get("levels_completed", 0))}
	]
	
	for item in stats_items:
		var label = Label.new()
		label.text = item["label"]
		label.add_theme_font_size_override("font_size", 18)
		grid.add_child(label)
		
		var value = Label.new()
		value.text = item["value"]
		value.add_theme_font_size_override("font_size", 24)
		value.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		grid.add_child(value)

func _format_time(seconds: float) -> String:
	var total_seconds = int(seconds)
	var hours = total_seconds / 3600
	var minutes = (total_seconds % 3600) / 60
	var secs = total_seconds % 60
	
	if hours > 0:
		return "%d小时%d分%d秒" % [hours, minutes, secs]
	elif minutes > 0:
		return "%d分%d秒" % [minutes, secs]
	else:
		return "%d秒" % secs

func _on_back_pressed() -> void:
	back_pressed.emit()
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")

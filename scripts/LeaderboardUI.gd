extends Control

## LeaderboardUI.gd - 排行榜界面
## 显示本地排行榜数据

signal back_pressed()

var leaderboard_data: Array[Dictionary] = []

@onready var grid: GridContainer = $LeaderboardGrid

func _ready() -> void:
	# 加载排行榜数据
	_load_leaderboard()
	
	# 创建排行榜显示
	_create_leaderboard_display()
	
	# 连接返回按钮
	$RankHeader.pressed.connect(_on_back_pressed)

func _load_leaderboard() -> void:
	var leaderboard = get_node_or_null("/root/LeaderboardManager")
	if leaderboard and leaderboard.has_method("get_leaderboard"):
		leaderboard_data = leaderboard.get_leaderboard()
	else:
		# 默认数据
		leaderboard_data = [
			{"name": "Player1", "score": 10000},
			{"name": "Player2", "score": 8000},
			{"name": "Player3", "score": 6000},
			{"name": "Player4", "score": 4000},
			{"name": "Player5", "score": 2000}
		]

func _create_leaderboard_display() -> void:
	# 表头
	var rank_header = Label.new()
	rank_header.text = "排名"
	rank_header.add_theme_font_size_override("font_size", 20)
	rank_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	grid.add_child(rank_header)
	
	var name_header = Label.new()
	name_header.text = "玩家"
	name_header.add_theme_font_size_override("font_size", 20)
	name_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	grid.add_child(name_header)
	
	var score_header = Label.new()
	score_header.text = "分数"
	score_header.add_theme_font_size_override("font_size", 20)
	score_header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	grid.add_child(score_header)
	
	# 显示排行数据
	for i in range(leaderboard_data.size()):
		var data = leaderboard_data[i]
		
		# 排名
		var rank_label = Label.new()
		if i == 0:
			rank_label.text = "🥇"
		elif i == 1:
			rank_label.text = "🥈"
		elif i == 2:
			rank_label.text = "🥉"
		else:
			rank_label.text = str(i + 1)
		rank_label.add_theme_font_size_override("font_size", 24)
		rank_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		grid.add_child(rank_label)
		
		# 玩家名
		var name_label = Label.new()
		name_label.text = data.get("name", "Unknown")
		name_label.add_theme_font_size_override("font_size", 18)
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		grid.add_child(name_label)
		
		# 分数
		var score_label = Label.new()
		score_label.text = str(data.get("score", 0))
		score_label.add_theme_font_size_override("font_size", 18)
		score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		grid.add_child(score_label)

func _on_back_pressed() -> void:
	back_pressed.emit()
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")

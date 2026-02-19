extends Control

## GameOverUI.gd - 游戏结束界面
## 显示游戏结束时的得分和统计

signal restart_game()
signal return_to_main_menu()

var final_score: int = 0
var high_score: int = 0
var is_new_record: bool = false
var game_stats: Dictionary = {}

func _ready() -> void:
	_update_display()
	_connect_buttons()

func _update_display() -> void:
	$CenterContainer/VBox/ScoreLabel.text = "本次得分: " + str(final_score)
	$CenterContainer/VBox/HighScoreLabel.text = "最高分: " + str(high_score)
	
	if is_new_record:
		$CenterContainer/VBox/NewHighScoreLabel.visible = true
	else:
		$CenterContainer/VBox/NewHighScoreLabel.visible = false
	
	# 显示统计
	var stats_text = ""
	stats_text += "🏆 最高连击: " + str(game_stats.get("highest_combo", 0)) + "\n"
	stats_text += "⏱️ 游戏时间: " + _format_time(game_stats.get("play_time", 0.0)) + "\n"
	stats_text += "🎯 击中次数: " + str(game_stats.get("targets_hit", 0))
	$CenterContainer/VBox/StatsLabel.text = stats_text

func _connect_buttons() -> void:
	$CenterContainer/VBox/ButtonsVBox/RestartButton.pressed.connect(_on_restart_pressed)
	$CenterContainer/VBox/ButtonsVBox/MainMenuButton.pressed.connect(_on_main_menu_pressed)

func set_score(score: int) -> void:
	final_score = score
	is_new_record = score > high_score

func set_high_score(score: int) -> void:
	high_score = score

func set_stats(stats: Dictionary) -> void:
	game_stats = stats

func _format_time(seconds: float) -> String:
	var total_seconds = int(seconds)
	var minutes = total_seconds / 60
	var secs = total_seconds % 60
	return "%d分%d秒" % [minutes, secs]

func _on_restart_pressed() -> void:
	restart_game.emit()
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_main_menu_pressed() -> void:
	return_to_main_menu.emit()
	get_tree().change_scene_to_file("res://scenes/ui/MainMenu.tscn")

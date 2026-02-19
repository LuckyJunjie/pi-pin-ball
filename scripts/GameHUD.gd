extends CanvasLayer

## GameHUD.gd - 游戏HUD界面
## 游戏过程中显示的分数、连击、球数等信息

@onready var score_label: Label = $TopBar/ScorePanel/ScoreLabel
@onready var combo_label: Label = $TopBar/ComboPanel/ComboLabel
@onready var balls_label: Label = $TopBar/BallPanel/BallsLabel
@onready var level_label: Label = $TopBar/LevelPanel/LevelLabel

func _ready() -> void:
	# 连接GameManager信号
	var game_manager = get_node_or_null("/root/GameManager")
	if game_manager:
		game_manager.connect("score_changed", _on_score_changed)
		game_manager.connect("multiplier_changed", _on_multiplier_changed)
		game_manager.connect("balls_changed", _on_balls_changed)

func _on_score_changed(new_score: int) -> void:
	score_label.text = "分数: " + str(new_score)

func _on_multiplier_changed(new_mult: int) -> void:
	combo_label.text = "x" + str(new_mult)
	# 连击时动画效果
	var tween = create_tween()
	tween.tween_property(combo_label, "scale", Vector2(1.5, 1.5), 0.1)
	tween.tween_property(combo_label, "scale", Vector2(1, 1), 0.1)

func _on_balls_changed(remaining: int) -> void:
	balls_label.text = "球: " + str(remaining)

func update_level(level: int) -> void:
	level_label.text = "关卡: " + str(level)

func show_pause_indicator() -> void:
	# 显示暂停图标
	pass

func hide_pause_indicator() -> void:
	# 隐藏暂停图标
	pass

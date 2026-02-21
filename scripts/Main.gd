extends Node2D

## Main.gd - 主场景
## 管理游戏主场景和UI

@onready var score_label: Label = $UI/ScoreLabel
@onready var multiplier_label: Label = $UI/MultiplierLabel
@onready var balls_label: Label = $UI/BallsLabel
@onready var launcher: Node2D = $Launcher
@onready var left_flipper: Node2D = $LeftFlipper
@onready var right_flipper: Node2D = $RightFlipper

func _ready() -> void:
	# 连接GameManager信号
	GameManager.game_started.connect(_on_game_started)
	GameManager.score_changed.connect(_on_score_changed)
	GameManager.multiplier_changed.connect(_on_multiplier_changed)
	GameManager.balls_changed.connect(_on_balls_changed)
	GameManager.game_over.connect(_on_game_over)
	GameManager.ball_lost_signal.connect(_on_ball_lost)
	
	# 等待开始游戏
	GameManager.current_state = GameManager.GameState.WAITING
	
	# 确保发射器有正确的位置
	if launcher:
		launcher.global_position = Vector2(720, 450)
	
	# 确保挡板在正确位置
	if left_flipper:
		left_flipper.global_position = Vector2(200, 500)
	if right_flipper:
		right_flipper.global_position = Vector2(900, 500)

func _process(_delta: float) -> void:
	# 处理输入
	if Input.is_action_just_pressed("ui_cancel"):
		if GameManager.is_playing():
			GameManager.pause_game()
		elif GameManager.current_state == GameManager.GameState.PAUSED:
			GameManager.resume_game()
	
	# 开始游戏 / 发射球
	if Input.is_action_just_pressed("ui_accept"):
		if GameManager.current_state == GameManager.GameState.WAITING:
			GameManager.start_game()
			# 发射球
			if launcher and launcher.has_method("launch"):
				launcher.launch()
	
	# 左挡板控制 (A键)
	if left_flipper and left_flipper.has_method("set_pressed"):
		if Input.is_action_pressed("ui_left"):
			left_flipper.set_pressed(true)
		else:
			left_flipper.set_pressed(false)
	
	# 右挡板控制 (D键)
	if right_flipper and right_flipper.has_method("set_pressed"):
		if Input.is_action_pressed("ui_right"):
			right_flipper.set_pressed(true)
		else:
			right_flipper.set_pressed(false)

func _on_game_started() -> void:
	print("[Main] Game started!")
	# 生成球

func _on_score_changed(new_score: int) -> void:
	if score_label:
		score_label.text = "Score: " + str(new_score)

func _on_multiplier_changed(new_mult: int) -> void:
	if multiplier_label:
		multiplier_label.text = "Multiplier: x" + str(new_mult)

func _on_balls_changed(remaining: int) -> void:
	if balls_label:
		balls_label.text = "Balls: " + str(remaining)

func _on_game_over() -> void:
	print("[Main] Game Over! Final Score: " + str(GameManager.get_score()))

func _on_ball_lost() -> void:
	print("[Main] Ball lost! Remaining: " + str(GameManager.get_remaining_balls()))

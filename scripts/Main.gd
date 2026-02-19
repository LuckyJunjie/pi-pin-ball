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
	GameManager.ball_lost.connect(_on_ball_lost)
	
	# 等待开始游戏
	GameManager.current_state = GameManager.GameState.WAITING

func _process(_delta: float) -> void:
	# 处理输入
	if Input.is_action_just_pressed("ui_cancel"):
		if GameManager.is_playing():
			GameManager.pause_game()
		elif GameManager.current_state == GameManager.GameState.PAUSED:
			GameManager.resume_game()
	
	# 开始游戏
	if Input.is_action_just_pressed("ui_accept"):
		if GameManager.current_state == GameManager.GameState.WAITING:
			GameManager.start_game()
		elif GameManager.is_playing():
			# 右挡板控制
			right_flipper.set("pressed_angle", 45)
	
	if Input.is_action_just_released("ui_accept"):
		if GameManager.is_playing():
			right_flipper.set("pressed_angle", 0)
	
	# 左挡板控制
	if Input.is_action_pressed("ui_left"):
		left_flipper.set("pressed_angle", 45)
	else:
		left_flipper.set("pressed_angle", 0)

func _on_game_started() -> void:
	print("Game started!")
	# 这里会生成球

func _on_score_changed(new_score: int) -> void:
	score_label.text = "Score: " + str(new_score)

func _on_multiplier_changed(new_mult: int) -> void:
	multiplier_label.text = "Multiplier: x" + str(new_mult)

func _on_balls_changed(remaining: int) -> void:
	balls_label.text = "Balls: " + str(remaining)

func _on_game_over() -> void:
	print("Game Over! Final Score: " + str(GameManager.get_score()))

func _on_ball_lost() -> void:
	print("Ball lost! Remaining: " + str(GameManager.get_remaining_balls()))

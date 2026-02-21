extends Node

## GameManager.gd - 游戏管理器
## 管理游戏状态、得分、倍率等核心逻辑

## 单例模式
static var instance: GameManager

## 信号
signal score_changed(new_score: int)
signal multiplier_changed(new_mult: int)
signal balls_changed(remaining: int)
signal game_started()
signal game_over()
signal game_paused(is_paused: bool)
signal ball_lost()
signal hit_registered(area: Node, points: int)

## 游戏状态
enum GameState { WAITING, PLAYING, PAUSED, GAME_OVER }

var current_state: GameState = GameState.WAITING
var game_score: int = 0
var game_multiplier: int = 1
var remaining_balls: int = 3
var total_score: int = 0
var high_score: int = 0

## 碰撞记录
var _hit_areas: Dictionary = {}  # {Area: last_hit_time}
var _combo_timeout: float = 2.0

## 角色系统
var character_system: Node = null

## 生命周期

func _ready() -> void:
	instance = self
	_load_high_score()
	_initialize_character_system()

func _initialize_character_system() -> void:
	# 创建角色系统
	character_system = load("res://scripts/CharacterSystem.gd").new()
	add_child(character_system)
	print("GameManager: 角色系统已初始化")

func _process(_delta: float) -> void:
	# 检查连击超时
	_check_combo_timeout()

## 得分管理

func add_score(points: int) -> void:
	if current_state != GameState.PLAYING:
		return
	
	# 应用角色得分加成
	var character_bonus: float = 1.0
	if character_system:
		character_bonus = character_system.get_multiplier(character_system.current_character_id)
	
	var final_points: int = int(points * character_bonus * game_multiplier)
	
	game_score += final_points
	total_score += final_points
	
	# 更新最高分
	if total_score > high_score:
		high_score = total_score
		_save_high_score()
	
	emit_signal("score_changed", game_score)
	
	# 播放得分音效
	SoundManager.play_score()

func get_multiplier() -> int:
	return game_multiplier

func increase_multiplier() -> void:
	if game_multiplier < 10:  # 最大倍率
		game_multiplier += 1
		emit_signal("multiplier_changed", game_multiplier)
		SoundManager.play_multiplier()

func reset_multiplier() -> void:
	game_multiplier = 1
	emit_signal("multiplier_changed", game_multiplier)

func reset_score() -> void:
	game_score = 0
	total_score = 0
	game_multiplier = 1
	emit_signal("score_changed", 0)
	emit_signal("multiplier_changed", 1)

## 游戏状态管理

func start_game() -> void:
	if current_state != GameState.WAITING:
		return
	
	current_state = GameState.PLAYING
	remaining_balls = 3
	reset_score()
	emit_signal("game_started")
	
	SoundManager.play_music("gameplay")

func pause_game() -> void:
	if current_state != GameState.PLAYING:
		return
	
	current_state = GameState.PAUSED
	emit_signal("game_paused", true)
	SoundManager.stop_music()

func resume_game() -> void:
	if current_state != GameState.PAUSED:
		return
	
	current_state = GameState.PLAYING
	emit_signal("game_paused", false)
	SoundManager.play_music("gameplay")

func end_game() -> void:
	current_state = GameState.GAME_OVER
	emit_signal("game_over")
	SoundManager.play_sfx("game_over")
	SoundManager.stop_music()

func ball_lost() -> void:
	if current_state != GameState.PLAYING:
		return
	
	remaining_balls -= 1
	emit_signal("balls_changed", remaining_balls)
	emit_signal("ball_lost")
	
	SoundManager.play_sfx("lose_ball")
	
	if remaining_balls <= 0:
		end_game()

## 碰撞记录

func record_hit(area: Node, points: int) -> void:
	var current_time: float = Time.get_ticks_msec() / 1000.0
	
	if _hit_areas.has(area):
		var last_hit: float = _hit_areas[area]
		if current_time - last_hit < _combo_timeout:
			# 连击
			increase_multiplier()
	
	_hit_areas[area] = current_time
	emit_signal("hit_registered", area, points)

func _check_combo_timeout() -> void:
	var current_time: float = Time.get_ticks_msec() / 1000.0
	var areas_to_remove: Array[Node] = []
	
	for area: Node in _hit_areas.keys():
		if current_time - _hit_areas[area] > _combo_timeout:
			areas_to_remove.append(area)
	
	for area: Node in areas_to_remove:
		_hit_areas.erase(area)
	
	# 如果没有碰撞，重置倍率
	if _hit_areas.is_empty():
		reset_multiplier()

## 音效管理
## SoundManager 现在是单例，直接使用静态方法

## 保存/加载

func _load_high_score() -> void:
	var save_file: FileAccess = FileAccess.open("user://highscore.save", FileAccess.READ)
	if save_file:
		high_score = save_file.get_64()
		save_file.close()

func _save_high_score() -> void:
	var save_file: FileAccess = FileAccess.open("user://highscore.save", FileAccess.WRITE)
	if save_file:
		save_file.store_64(high_score)
		save_file.close()

## 公共查询

func is_playing() -> bool:
	return current_state == GameState.PLAYING

func is_game_over() -> bool:
	return current_state == GameState.GAME_OVER

func get_score() -> int:
	return total_score

func get_high_score() -> int:
	return high_score

func get_remaining_balls() -> int:
	return remaining_balls

## 游戏重启

func restart_game() -> void:
	reset_score()
	remaining_balls = 3
	_hit_areas.clear()
	current_state = GameState.WAITING

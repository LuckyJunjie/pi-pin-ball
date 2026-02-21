# PI-PinBall 单元测试
# 基于 Godot 内置测试框架

extends GutTest

## 测试 GameManager 核心功能

func test_game_manager_singleton() -> void:
	# 验证 GameManager 是单例
	var gm = GameManager.get_instance()
	assert_not_null(gm, "GameManager should be accessible")

func test_game_manager_initial_state() -> void:
	# 验证初始状态
	var gm = GameManager.get_instance()
	assert_eq(gm.current_state, gm.GameState.WAITING, "初始状态应为 WAITING")
	assert_eq(gm.get_remaining_balls(), 3, "初始球数应为 3")
	assert_eq(gm.get_score(), 0, "初始分数应为 0")

func test_add_score() -> void:
	# 验证得分功能
	var gm = GameManager.get_instance()
	gm.start_game()
	gm.add_score(100)
	assert_eq(gm.get_score(), 100, "得分应为 100")

func test_multiplier() -> void:
	# 验证倍率功能
	var gm = GameManager.get_instance()
	gm.start_game()
	gm.increase_multiplier()
	assert_eq(gm.get_multiplier(), 2, "倍率应为 2")
	gm.reset_multiplier()
	assert_eq(gm.get_multiplier(), 1, "倍率应重置为 1")

func test_ball_lost() -> void:
	# 验证球掉落
	var gm = GameManager.get_instance()
	gm.start_game()
	var initial_balls = gm.get_remaining_balls()
	gm.ball_lost()
	assert_eq(gm.get_remaining_balls(), initial_balls - 1, "球数应减少 1")

func test_game_over() -> void:
	# 验证游戏结束
	var gm = GameManager.get_instance()
	gm.start_game()
	gm.remaining_balls = 0
	gm.ball_lost()
	assert_true(gm.is_game_over(), "游戏应结束")

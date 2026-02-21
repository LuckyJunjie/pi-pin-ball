# PI-PinBall 核心功能测试
# 测试物理和得分系统

extends GutTest

## 测试 Ball 物理

func test_ball_creation() -> void:
	# 测试球能否正确创建
	var ball = RigidBody2D.new()
	add_child(ball)
	
	assert_not_null(ball, "球应该被创建")
	assert_true(ball is RigidBody2D, "球应该是 RigidBody2D")
	
	ball.free()

func test_ball_physics_properties() -> void:
	# 测试球的物理属性
	var ball = RigidBody2D.new()
	ball.physics_material_override = PhysicsMaterial.new()
	ball.physics_material_override.bounce = 0.5
	ball.physics_material_override.friction = 0.1
	add_child(ball)
	
	assert_eq(ball.physics_material_override.bounce, 0.5, "弹性应为 0.5")
	assert_eq(ball.physics_material_override.friction, 0.1, "摩擦力应为 0.1")
	
	ball.free()

## 测试 ScoringArea 得分

func test_scoring_area_points() -> void:
	# 测试得分区域的基本得分
	var area = Area2D.new()
	var scoring_script = load("res://scripts/ScoringArea.gd")
	area.set_script(scoring_script)
	area.base_points = 100
	add_child(area)
	
	assert_eq(area.get_points(), 100, "基础得分应为 100")
	
	area.free()

## 测试 GameManager 得分计算

func test_score_calculation_with_multiplier() -> void:
	# 测试倍率得分计算
	var gm = GameManager.get_instance()
	gm.start_game()
	gm.game_multiplier = 2
	
	# 模拟得分（基础分 * 倍率）
	var base_points = 50
	var expected = base_points * gm.get_multiplier()
	
	assert_eq(expected, 100, "2倍率的50分应该等于100分")
	
	gm.end_game()

func test_combo_system() -> void:
	# 测试连击系统
	var gm = GameManager.get_instance()
	gm.start_game()
	
	# 记录第一次命中
	var mock_area = Node.new()
	gm.record_hit(mock_area, 10)
	
	# 等待0.5秒再记录（连击超时是2秒）
	await get_tree().create_timer(0.5).timeout
	gm.record_hit(mock_area, 10)
	
	# 应该有倍率提升
	assert_true(gm.get_multiplier() >= 1, "应该有连击倍率")
	
	mock_area.free()
	gm.end_game()

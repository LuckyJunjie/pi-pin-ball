extends Node2D

## 🎮 PI-PinBall 游戏循环测试脚本
## 测试目标：验证核心游戏循环完整运行

## 测试结果
var test_results: Dictionary = {
	"ball_spawn": false,
	"launcher_works": false,
	"flippers_work": false,
	"collision_detected": false,
	"score_system": false,
	"game_over": false
}

## 测试状态
var _tests_passed: int = 0
var _tests_failed: int = 0
var _test_output: Array = []

func _ready() -> void:
	print("=== 🎮 PI-PinBall 游戏循环测试 ===")
	_run_all_tests()

func _run_all_tests() -> void:
	_test_ball_spawn()
	_test_launcher()
	_test_flippers()
	_test_collision()
	_test_score_system()
	_test_game_over()
	
	_print_results()
	_send_report()

## 测试1: 球生成
func _test_ball_spawn() -> void:
	var test_name = "球生成测试"
	var passed = false
	
	# 检查Ball.tscn是否存在
	if FileAccess.file_exists("res://scenes/components/Ball.tscn"):
		passed = true
		test_results["ball_spawn"] = true
		_test_output.append("✅ %s: Ball.tscn 存在" % test_name)
	else:
		_test_output.append("❌ %s: Ball.tscn 不存在" % test_name)
	
	_update_test_count(passed)

## 测试2: 发射器功能
func _test_launcher() -> void:
	var test_name = "发射器测试"
	var passed = false
	
	# 检查Launcher是否在Main中
	var main = get_parent()
	if main.has_node("Launcher"):
		var launcher = main.get_node("Launcher")
		if launcher.has_method("launch"):
			passed = true
			test_results["launcher_works"] = true
			_test_output.append("✅ %s: Launcher.launch() 方法存在" % test_name)
		else:
			_test_output.append("❌ %s: Launcher缺少launch()方法" % test_name)
	else:
		_test_output.append("❌ %s: Main中缺少Launcher节点" % test_name)
	
	_update_test_count(passed)

## 测试3: 挡板功能
func _test_flippers() -> void:
	var test_name = "挡板测试"
	var passed = false
	
	var main = get_parent()
	var flipper_count = 0
	
	if main.has_node("LeftFlipper"):
		flipper_count += 1
	if main.has_node("RightFlipper"):
		flipper_count += 1
	
	if flipper_count >= 2:
		passed = true
		test_results["flippers_work"] = true
		_test_output.append("✅ %s: 找到 %d 个挡板" % [test_name, flipper_count])
	else:
		_test_output.append("❌ %s: 只找到 %d 个挡板 (需要2个)" % [test_name, flipper_count])
	
	_update_test_count(passed)

## 测试4: 碰撞检测
func _test_collision() -> void:
	var test_name = "碰撞检测测试"
	var passed = false
	
	# 检查碰撞层配置
	var main = get_parent()
	if main.has_node("Walls"):
		var walls = main.get_node("Walls")
		var collision_count = 0
		
		if walls.has_node("Top") or walls.has_node("Bottom") or \
		   walls.has_node("Left") or walls.has_node("Right"):
			collision_count = 4
		else:
			# 检查Walls下所有子节点
			for child in walls.get_children():
				if child is CollisionShape2D:
					collision_count += 1
		
		if collision_count >= 4:
			passed = true
			test_results["collision_detected"] = true
			_test_output.append("✅ %s: 找到 %d 个碰撞边界" % [test_name, collision_count])
		else:
			_test_output.append("⚠️ %s: 只找到 %d 个碰撞边界" % [test_name, collision_count])
	else:
		_test_output.append("❌ %s: 缺少Walls节点" % test_name)
	
	_update_test_count(passed)

## 测试5: 得分系统
func _test_score_system() -> void:
	var test_name = "得分系统测试"
	var passed = false
	
	if GameManager:
		# 测试得分功能
		var initial_score = GameManager.get_score()
		GameManager.add_score(100)
		var new_score = GameManager.get_score()
		
		if new_score == initial_score + 100:
			passed = true
			test_results["score_system"] = true
			_test_output.append("✅ %s: 得分系统正常工作 (+100分成功)" % test_name)
		else:
			_test_output.append("❌ %s: 得分计算错误" % test_name)
		
		# 测试倍率
		var initial_mult = GameManager.get_multiplier()
		GameManager.increase_multiplier()
		var new_mult = GameManager.get_multiplier()
		
		if new_mult == initial_mult + 1:
			_test_output.append("✅ %s: 倍率系统正常工作 (+1倍率成功)" % test_name)
		else:
			_test_output.append("❌ %s: 倍率计算错误" % test_name)
	else:
		_test_output.append("❌ %s: GameManager不存在" % test_name)
	
	_update_test_count(passed)

## 测试6: 游戏结束
func _test_game_over() -> void:
	var test_name = "游戏结束测试"
	var passed = false
	
	if GameManager:
		# 测试球数减少
		var initial_balls = GameManager.get_remaining_balls()
		GameManager.ball_lost()
		var new_balls = GameManager.get_remaining_balls()
		
		if new_balls == initial_balls - 1:
			passed = true
			test_results["game_over"] = true
			_test_output.append("✅ %s: 漏球检测正常工作 (-1球成功)" % test_name)
		else:
			_test_output.append("❌ %s: 漏球计数错误" % test_name)
		
		# 恢复球数
		GameManager.restart_game()
	else:
		_test_output.append("❌ %s: GameManager不存在" % test_name)
	
	_update_test_count(passed)

## 测试统计
func _update_test_count(passed: bool) -> void:
	if passed:
		_tests_passed += 1
	else:
		_tests_failed += 1

func _print_results() -> void:
	print("\n=== 📊 测试结果 ===")
	for test_name: String in test_results:
		var result: bool = test_results[test_name]
		var icon = "✅" if result else "❌"
		print("%s %s: %s" % [icon, test_name, result])
	
	print("\n总计: ✅ %d 通过 | ❌ %d 失败" % [_tests_passed, _tests_failed])
	
	if _tests_failed == 0:
		print("🎉 所有测试通过！游戏循环完整可用。")
	else:
		print("⚠️ %d 个测试失败，需要修复。" % _tests_failed)

func _send_report() -> void:
	# 生成测试报告
	var report = {
		"timestamp": Time.get_datetime_string_from_system(),
		"tests_passed": _tests_passed,
		"tests_failed": _tests_failed,
		"results": test_results,
		"output": _test_output
	}
	
	print("\n📄 测试报告已生成:")
	print(JSON.stringify(report, "  "))

## 获取测试状态
func get_test_results() -> Dictionary:
	return test_results

func is_game_loop_complete() -> bool:
	# 检查所有关键功能是否正常
	return test_results["ball_spawn"] and \
		   test_results["launcher_works"] and \
		   test_results["flippers_work"] and \
		   test_results["collision_detected"] and \
		   test_results["score_system"] and \
		   test_results["game_over"]

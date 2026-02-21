# PI-PinBall 测试运行脚本
# 运行方法: godot --path . --headless -s test/run_tests.gd

extends Gut

func _ready() -> void:
	# 配置 Gut 测试运行器
	gut.config.add_directory_to_auto_include("test", ".gd")
	
	# 运行所有测试
	print("开始运行 PI-PinBall 单元测试...")
	gut.run_tests()

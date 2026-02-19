extends Node2D

## ThemeArea.gd - 主题区域组件
## 每个关卡有不同的视觉主题和障碍物布局

@export var theme_name: String = "Android Acres"
@export var difficulty: float = 1.0

## 主题颜色
var theme_colors: Dictionary = {
	"Android Acres": Color(0.2, 0.8, 0.2),      # 绿色
	"Flutter Forest": Color(0.1, 0.6, 0.3),     # 深绿
	"Dart Canyon": Color(0.8, 0.4, 0.1),          # 橙色
	"Firebase Falls": Color(0.2, 0.5, 0.9),     # 蓝色
	"Google Gardens": Color(0.9, 0.7, 0.2)       # 金色
}

## 区域类型
enum AreaType {
	BOOST,      # 加速区
	SLOW,       # 减速区
	MULTIPLIER, # 倍率区
	BONUS,      # 奖励区
	HAZARD      # 危险区
}

func _ready() -> void:
	_setup_theme()

func _setup_theme() -> void:
	# 根据主题设置颜色
	var color = theme_colors.get(theme_name, Color.WHITE)
	modulate = color
	print("ThemeArea: 主题设置为 ", theme_name)

## 获取区域类型
func get_area_type() -> AreaType:
	return AreaType.BONUS

## 触发区域效果
func trigger_effect(body: Node2D) -> void:
	match get_area_type():
		AreaType.BOOST:
			if body.has_method("apply_speed_boost"):
				body.apply_speed_boost(1.5)
		AreaType.SLOW:
			if body.has_method("apply_speed_slow"):
				body.apply_speed_slow(0.5)
		AreaType.MULTIPLIER:
			if body.has_method("apply_multiplier"):
				body.apply_multiplier(2.0)
		AreaType.BONUS:
			if body.has_method("add_score"):
				body.add_score(int(100 * difficulty))
		AreaType.HAZARD:
			if body.has_method("take_damage"):
				body.take_damage(1)

## 设置主题
func set_theme(name: String) -> void:
	theme_name = name
	_setup_theme()

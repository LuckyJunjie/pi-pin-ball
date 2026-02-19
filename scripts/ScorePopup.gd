extends Label

## ScorePopup.gd - 分数弹出效果
## 显示得分动画

## 生命周期

func _ready() -> void:
	# 设置初始属性
	modulate = Color.YELLOW
	z_index = 100
	
	# 淡出动画
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	tween.tween_property(self, "position", position + Vector2(0, -50), 1.0)
	tween.tween_callback(queue_free)

## 公共方法

func setup(points: int) -> void:
	text = str(points)

extends Sprite2D

## HitEffect.gd - 命中效果
## 显示碰撞时的视觉反馈

## 生命周期

func _ready() -> void:
	# 设置为半透明
	modulate.a = 0.5
	
	# 淡出并缩小
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.tween_property(self, "scale", scale * 1.5, 0.3)
	tween.tween_callback(queue_free)

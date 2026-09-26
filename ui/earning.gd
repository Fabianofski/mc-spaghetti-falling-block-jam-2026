extends Label

@export var duration: float = 1.0
@export var target_position: Vector2 = Vector2.ZERO
@export var rotation_angle: float = -12.0 

func _ready() -> void:
	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector2.ONE * 0.8, duration)\
	.set_trans(Tween.TRANS_BACK)\
	.set_ease(Tween.EASE_OUT)
	await tween.finished
	
	animate_to_top_left()

func animate_to_top_left() -> void:

	pivot_offset = size / 2.0
	
	var tween: Tween = create_tween().set_parallel(true)
	
	tween.tween_property(self, "global_position", target_position, duration)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
		
	tween.tween_property(self, "rotation_degrees", rotation_angle, duration)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
		
	tween.tween_property(self, "scale", Vector2.ZERO, duration)\
		.set_trans(Tween.TRANS_CUBIC)\
		.set_ease(Tween.EASE_OUT)
		
	await tween.finished
	queue_free()

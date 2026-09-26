extends Node2D

@onready var sprite: Sprite2D = $sprite
var constant_offset_time: float = 0.0
var random_offset: float = 0.0
const ANIM_TIME: float = 0.3
@export_enum("Still", "Left", "Right") var movement_dir: String = "Still"
@export var is_generic: bool = true
var wait_time: float

var movement_tween: Tween

func _ready() -> void:
	random_offset = randf()
	if is_generic: sprite.frame = randi_range(0, 11)
	else:
		sprite.hframes = 1
		sprite.vframes = 1

func _process(delta: float) -> void:
	if global_position.x < -256 or global_position.x > 1536:
		if is_generic: sprite.frame = randi_range(0, 11)
		match movement_dir:
			"Left": global_position.x = -256
			"Right": global_position.x = 1536
	
	if wait_time > 0.0:
		wait_time -= delta
		return
	
	var offset: float = (sin(constant_offset_time * ANIM_TIME) * 0.15) - (random_offset / 16)
	constant_offset_time += delta + (random_offset / 8)
	rotation = offset
	position += Vector2(-offset, -offset / 4)
	
	match movement_dir:
		"Left":
			global_position.x += delta * (32 + (random_offset * 16))
			sprite.flip_h = true
		"Right": global_position.x -= delta * (32 + (random_offset * 16))

func play_anim(anim: String = "appear"):
	match anim:
		"appear":
			var starting_y: int
			self.position.y += 256
			if movement_tween: movement_tween.kill()
			movement_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			movement_tween.tween_property(self, "position:y", starting_y, 1)
		"order_done":
			if movement_tween: movement_tween.kill()
			movement_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			movement_tween.tween_property(self, "position:y", self.position.y - 256, 0.25)
			await movement_tween.finished
			if movement_tween: movement_tween.kill()
			movement_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
			movement_tween.tween_property(self, "position:y", self.position.y + 496, 0.25)
			await movement_tween.finished
			self.queue_free()

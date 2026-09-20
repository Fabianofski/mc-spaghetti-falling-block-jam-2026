extends Button
class_name JuicyButtonAwwYiss

@onready var hover_sound: AudioStream = preload("res://audio/hover.ogg")
@onready var click_sound: AudioStream  = preload("res://audio/click.ogg")

const DEFAULT_SCALE: Vector2 = Vector2.ONE
const HOVERING_SCALE: Vector2 = Vector2(1.2, 1.2)
const SQUISHED_SCALE: Vector2 = Vector2(1.15, 0.9)

const ANIM_TIME: float = 0.4
var constant_offset_time: float = 0.0
var random_offset: float = 0.0

var should_oscillate: bool = false
var _tween: Tween = null

func _ready() -> void:
	offset_transform_enabled = true
	
	theme = load("res://art_assets/theme.tres")
	
	random_offset = randf()
	
	mouse_entered.connect(_on_button_mouse_entered)
	mouse_exited.connect(_on_button_mouse_exited)
	button_up.connect(_on_button_mouse_exited)
	button_down.connect(_on_button_down)

func _process(delta: float) -> void:
	if should_oscillate:
		constant_offset_time += delta + (random_offset / 8)
		offset_transform_rotation = (sin(constant_offset_time * ANIM_TIME) * 0.15) - (random_offset / 16)
		
func play_sound(clip): 
	var audio = AudioStreamPlayer2D.new() 
	audio.stream = clip
	audio.pitch_scale = 3
	add_child(audio)

	audio.play()
	audio.finished.connect(func(): audio.queue_free())

func _on_button_mouse_entered() -> void:
	if _tween: _tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "offset_transform_scale", HOVERING_SCALE, ANIM_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	play_sound(hover_sound)

func _on_button_mouse_exited() -> void:
	if _tween: _tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "offset_transform_scale", DEFAULT_SCALE, ANIM_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)

func _on_button_down() -> void:
	if _tween: _tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "offset_transform_scale", SQUISHED_SCALE, ANIM_TIME / 2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	play_sound(click_sound)

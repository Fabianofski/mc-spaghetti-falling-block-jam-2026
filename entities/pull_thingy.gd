extends Sprite2D
class_name PullThingy

var _is_pressed_on_sprite = false
var start_global_y: float
var init_y: float
var target_pos: float

@export var max_pullout: float = 100.0 
@onready var windAudio: AudioStreamPlayer2D = $WindUpAudio
@onready var springBackAudio: AudioStreamPlayer2D = $SpringBackAudio
@onready var tutorial: AnimatedSprite2D = $"Pull Thingus Tutorial"

var is_pressed: bool 
var threshold: float = 0.95

signal cancelled
signal pressed


func _ready() -> void:
	init_y = position.y
	SignalBus.done_cooking.connect(release)
	if GameManager.current_day > 0: tutorial.hide()

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		var is_inside = get_rect().has_point(get_local_mouse_position())
		
		if event.is_pressed():
			if is_inside:
				_is_pressed_on_sprite = true
				start_global_y = get_global_mouse_position().y
				get_viewport().set_input_as_handled()
			else:
				_is_pressed_on_sprite = false
				
		elif event.is_released():
			if _is_pressed_on_sprite:
				get_viewport().set_input_as_handled()
			_is_pressed_on_sprite = false

func _process(delta: float) -> void:
	if not _is_pressed_on_sprite: 
		windAudio.stop()
		target_pos = init_y
		if is_pressed:
			tutorial.frame = 0
			cancelled.emit()
			springBackAudio.play()
			is_pressed = false
	else:
		var current_global_y = get_global_mouse_position().y
		var pull_distance = current_global_y - start_global_y

		var pullout = clamp(pull_distance, 0.0, max_pullout)
		var percentage = pull_distance / max_pullout
		
		if not is_pressed and percentage >= threshold:
			is_pressed = true 
			tutorial.frame = 1
			pressed.emit()
		elif is_pressed and percentage <= threshold:
			is_pressed = false
			tutorial.frame = 0
			cancelled.emit()

		target_pos = init_y + pullout
		
	if target_pos != position.y:
		if not windAudio.playing:
			windAudio.play()
	else:
		windAudio.stop()
		springBackAudio.stop()
	
	position.y = lerp(position.y, target_pos, 10.0 * delta)
	
func release(): 
	_is_pressed_on_sprite = false

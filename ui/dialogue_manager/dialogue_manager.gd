extends Control
class_name DialogueManager

@onready var dialogue_node: Node = $Dialogue
@onready var label: RichTextLabel = $Dialogue/Background/Label
@onready var character: TextureRect = $"Character Pivot/Character"
@onready var character_pivot: Control = $"Character Pivot"
@onready var animated_background: Polygon2D = $"Dialogue/Animated Background"
var current_idx = 0
var text_tween: Tween

const WHOOSH = preload("uid://rwwt6casln2o")
var current_character: Character
var movement_tween: Tween
var extra_tween_just_for_launching: Tween
var tweening_out: bool
var launch_speed: float = 1.0

var animated_background_points: PackedVector2Array = [Vector2(80.0, 53.0),
	Vector2(454.0, 53.0),
	Vector2(454.0, 216.0),
	Vector2(80.0, 216.0),
	]

const ANIM_TIME: float = 0.8
var constant_offset_time: float = 0.0
var random_offset: float = 0.0

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_STOP
	random_offset = randf()
	next_dialogue()

func _process(delta: float) -> void:
	var offset: float = (sin(constant_offset_time * ANIM_TIME) * 0.15) - (random_offset / 16)
	constant_offset_time += delta + (random_offset / 8)
	if not tweening_out:
		character_pivot.rotation = offset
		character_pivot.position += Vector2(-offset, -offset / 4)
	
	# believe it or not only this worked
	if dialogue_node.visible:
		var point0: Vector2 = animated_background_points[0] + Vector2(-offset * 4, -offset * 16)
		var point1: Vector2 = animated_background_points[1] + Vector2(-offset * 16, -offset * 4)
		var point2: Vector2 = animated_background_points[2] + Vector2(offset * 16, -offset * 8)
		var point3: Vector2 = animated_background_points[3] + Vector2(offset * 8, offset * 16)
		var final_anim_bg_points: PackedVector2Array = [point0, point1, point2, point3]
		animated_background.polygon = final_anim_bg_points

func _input(event) -> void:
	var day = GameManager.get_day()
	if day.dialogue_played: return
	if event is InputEventMouseButton and event.is_pressed(): 
		if text_tween and text_tween.is_running():
			text_tween.stop()
			label.visible_ratio = 1
		else: 
			next_dialogue()
		
func next_dialogue(): 
	var day = GameManager.get_day()
	if day.dialogue_played or current_idx >= len(day.dialogue):
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		day.start()
		dialogue_node.visible = false
		day.dialogue_played = true
		_play_puppet_animation("launch")
		return

	var dialogue = day.dialogue[current_idx]
	if current_character != dialogue.character:
		match current_character:
			null:
				print("Dialogue: no character yet, must be just starting")
				_play_puppet_animation("appear")
				tweening_out = false
				current_character = dialogue.character
				character.texture = dialogue.character.avatar
			_:
				print("Dialogue: different character!!!")
				_play_puppet_animation("launch")
				await extra_tween_just_for_launching.finished
				random_offset = randf()
				current_character = dialogue.character
				character.texture = dialogue.character.avatar
				launch_speed = max(0.5, launch_speed - 0.1)
				_play_puppet_animation("appear")
				tweening_out = false

	if text_tween: 
		text_tween.kill()
	text_tween = create_tween()
	text_tween.tween_method(func(i): label.visible_ratio = i, 0.0, 1.0, len(dialogue.text) / 50.0)

	label.text = dialogue.text

	if dialogue.action != "":
		SignalBus.emit_signal(dialogue.action)

	current_idx += 1

func _play_puppet_animation(anim: String = "idle") -> void: # they say you should care about code quality, they never said it had to be good quality :)
	tweening_out = true
	match anim:
		"idle":
			pass # nvm i do it in process
		"appear":
			character_pivot.position = Vector2(1232, 1280)
			character_pivot.rotation_degrees = 0.0
			if movement_tween: movement_tween.kill()
			movement_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			movement_tween.tween_property(character_pivot, "position", Vector2(1232, 856), 1)
		"launch":
			var audio = AudioStreamPlayer2D.new() 
			audio.stream = WHOOSH
			audio.pitch_scale = remap(launch_speed, 1.0, 0.5, 1.0, 2.0)
			add_child(audio)
			audio.play()
			audio.finished.connect(func(): audio.queue_free())
			
			if extra_tween_just_for_launching: extra_tween_just_for_launching.kill()
			extra_tween_just_for_launching = create_tween().set_parallel()
			extra_tween_just_for_launching.tween_property(character_pivot, "position:x", -640, launch_speed)
			extra_tween_just_for_launching.tween_property(character_pivot, "rotation_degrees", 90.0, launch_speed)
			if movement_tween: movement_tween.kill()
			movement_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
			movement_tween.tween_property(character_pivot, "position:y", 368, launch_speed / 2)
			await movement_tween.finished
			if movement_tween: movement_tween.kill()
			movement_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
			movement_tween.tween_property(character_pivot, "position:y", 1280, launch_speed / 2)

extends Control

@onready var credits: ColorRect = $Credits
@onready var clouds: Sprite2D = $Clouds

func _ready() -> void:
	$"HBoxContainer/Start Button".should_oscillate = true
	$"HBoxContainer/Credits Button".should_oscillate = true
	$"HBoxContainer/Quit Button".should_oscillate = true
	credits.hide()

func _process(delta: float) -> void:
	if clouds.global_position.x < 2690: clouds.global_position.x += delta * 10
	elif clouds.global_position.x >= 2690:
		clouds.global_position.x = -1280
		clouds.global_position.y = randi_range(568, 768)

func _on_start_button_button_up() -> void:
	GameManager.reset()
	ScreenFader.change_scene("res://scenes/game.tscn")

func _on_credits_button_button_up() -> void:
	credits.show()

func _on_quit_button_button_up() -> void:
	ScreenFader.change_scene("QUIT")

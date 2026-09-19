extends Control

@onready var restart_button: JuicyButtonAwwYiss = $"VBoxContainer/Restart Button"

func _ready() -> void:
	SignalBus.game_over.connect(func(): visible = true)
	restart_button.should_oscillate = true

func restart():
	GameManager.reload_scene(true)

func _on_main_menu_button_button_up() -> void:
	Engine.time_scale = 1
	ScreenFader.change_scene("res://scenes/main_menu.tscn")

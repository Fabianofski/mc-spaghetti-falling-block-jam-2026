extends Control

func _ready() -> void:
	SignalBus.game_over.connect(func(): visible = true)

func restart():
	GameManager.reload_scene(true)

func _on_main_menu_button_button_up() -> void:
	Engine.time_scale = 1
	ScreenFader.change_scene("res://scenes/main_menu.tscn")

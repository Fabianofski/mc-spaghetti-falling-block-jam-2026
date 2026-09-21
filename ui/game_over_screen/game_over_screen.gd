extends Control

@onready var restart_button: JuicyButtonAwwYiss = $"VBoxContainer/Restart Button"

func _ready() -> void:
	var day = GameManager.get_day()
	day.failed.connect(func(): visible = true)
	day.failed.connect(func(): SignalBus.game_state_change.emit("menu"))
	restart_button.should_oscillate = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func restart():
	GameManager.reload_scene(true)

func _on_main_menu_button_button_up() -> void:
	ScreenFader.change_scene("res://scenes/main_menu.tscn")

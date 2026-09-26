extends Control

@onready var day_failed: Control = $DayFailed
@onready var day_success: Control = $DaySuccess
@onready var next_day_btn: JuicyButtonAwwYiss = $DaySuccess/Button
@onready var restart_button: JuicyButtonAwwYiss = $"DayFailed/VBoxContainer/Restart Button"

func _ready() -> void:
	var day = GameManager.get_day()
	day.succeeded.connect(func(): enable_screen(false))
	next_day_btn.should_oscillate = true

	day.failed.connect(func(): enable_screen(true))
	restart_button.should_oscillate = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func restart():
	GameManager.reload_scene(true)

func _on_main_menu_button_button_up() -> void:
	ScreenFader.change_scene("res://scenes/main_menu.tscn")
	
func enable_screen(fail: bool):
	day_failed.visible = fail
	day_success.visible = not fail
	if fail:
		SignalBus.game_state_change.emit("day_failed")
	else:
		SignalBus.game_state_change.emit("day_success")
	
	visible = true
	mouse_filter = Control.MOUSE_FILTER_STOP

func finish_day():
	GameManager.finish_day()

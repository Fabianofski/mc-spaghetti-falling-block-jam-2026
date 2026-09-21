extends Control

@onready var button: JuicyButtonAwwYiss = $Button

func _ready() -> void:
	var day = GameManager.get_day()
	day.succeeded.connect(enable_screen)
	button.should_oscillate = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
func enable_screen():
	visible = true
	SignalBus.game_state_change.emit("menu")
	mouse_filter = Control.MOUSE_FILTER_STOP

func finish_day():
	GameManager.finish_day()

extends Control

@onready var button: JuicyButtonAwwYiss = $Button

func _ready() -> void:
	SignalBus.day_finished.connect(enable_screen)
	button.should_oscillate = true
	
func enable_screen():
	visible = true

func finish_day():
	GameManager.finish_day()

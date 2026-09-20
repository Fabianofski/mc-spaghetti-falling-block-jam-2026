extends Control

@onready var button: JuicyButtonAwwYiss = $Button

func _ready() -> void:
	var day = GameManager.get_day()
	day.succeeded.connect(enable_screen)
	button.should_oscillate = true
	
func enable_screen():
	visible = true

func finish_day():
	GameManager.finish_day()

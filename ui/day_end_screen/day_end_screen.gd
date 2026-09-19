extends Control

func _ready() -> void:
    SignalBus.day_finished.connect(enable_screen)
    
func enable_screen():
    visible = true

func finish_day():
    GameManager.finish_day()
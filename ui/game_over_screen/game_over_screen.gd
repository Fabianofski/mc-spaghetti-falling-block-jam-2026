extends Control

func _ready() -> void:
	SignalBus.game_over.connect(func(): visible = true)

func restart():
	GameManager.reload_scene(true)

extends Node2D 

var current_day: int = 0
var score: int = 0

func _ready() -> void:
	SignalBus.game_over.connect(on_game_over)

func finish_day():
	current_day += 1
	reload_scene()
	
func reload_scene(is_loss: bool = false):
	if is_loss:
		current_day = 0
		score = 0
	get_tree().reload_current_scene()
	Engine.time_scale = 1
	
func get_day(): 
	return current_day

func on_game_over(): 
	Engine.time_scale = 0.1

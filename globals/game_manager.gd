extends Node2D 

var current_day: int = 0
var score: int = 0

var lost: bool

func _ready() -> void:
	SignalBus.game_over.connect(on_game_over)

func finish_day():
	current_day += 1
	reload_scene()
	
func reload_scene(is_loss: bool = false):
	if is_loss:
		current_day = 0
		score = 0
		lost = false
	Engine.time_scale = 1
	ScreenFader.change_scene("RELOAD")

func get_day(): 
	return current_day

func on_game_over():
	lost = true
	get_tree().paused = true

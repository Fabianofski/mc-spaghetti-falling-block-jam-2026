extends Node2D 

var days: Array[Day] = []
var current_day: int = 0

func _ready() -> void:
	for day_file in ResourceLoader.list_directory("res://resources/days"):
		var day_path = "res://resources/days/" + day_file
		var day = ResourceLoader.load(day_path)
		days.append(day)
	days.sort_custom(func(a, b): return a.day < b.day)

func finish_day():
	current_day += 1
	reload_scene()
	
func reload_scene(is_loss: bool = false):
	if is_loss:
		reset()

	ScreenFader.change_scene("RELOAD")
	SignalBus.game_state_change.emit("gameplay")
	OrderBook.reset_orders()
	
func reset(): 
	for day in days:
		day.reset()
	current_day = 0
	OrderBook.reset_orders()
	
func get_day(): 
	var idx = min(current_day, len(days) - 1) 
	return days[idx]

func get_day_idx(): 
	return current_day

func on_game_over():
	get_tree().paused = true

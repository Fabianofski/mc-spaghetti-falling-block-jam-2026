extends Node2D 

var current_day: int = 0
var score: int = 0

func finish_day():
    current_day += 1
    get_tree().reload_current_scene()
    
func get_day(): 
    return current_day
extends Control 
class_name OrderViewer

var order: Order 
@onready var meals: VBoxContainer = $Meals
@onready var meal_viewer: PackedScene = preload("res://ui/order_viewer/meal_viewer/meal_viewer.tscn")
@onready var time_left : ProgressBar = $TimeLeft
@onready var time_left_percentage: Label = $TimeLeft/Label

func on_order_completed(): 
	queue_free()

func set_order(_order: Order):
	order = _order
	order.completed.connect(on_order_completed)

	for idx in len(order.meals): 
		var meal = order.meals[idx]
		var mv = meal_viewer.instantiate()
		meals.add_child(mv)
		mv.set_meal(idx + 1, meal)
		
func _process(_delta: float) -> void:
	time_left.value = order.timer / order.time
	
	if time_left.value > 0: time_left_percentage.text = str(int(time_left.value * 100)) + "%"
	else: time_left_percentage.text = "MISSED"
	
	if time_left.value < 0.25 and not time_left.indeterminate: time_left.indeterminate = true

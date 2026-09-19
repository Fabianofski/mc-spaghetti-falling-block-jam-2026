extends Control 
class_name OrderViewer

var order: Order 
@onready var meals: VBoxContainer = $Meals
@onready var meal_viewer: PackedScene = preload("res://ui/order_viewer/meal_viewer/meal_viewer.tscn")
	
func on_order_completed(): 
	queue_free()

func set_order(_order: Order):
	order = _order
	order.order_completed.connect(on_order_completed)

	for idx in len(order.meals): 
		var meal = order.meals[idx]
		var mv = meal_viewer.instantiate()
		meals.add_child(mv)
		mv.set_meal(idx + 1, meal)

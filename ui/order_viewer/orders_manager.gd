extends HBoxContainer
class_name OrdersManager

@onready var order_viewer: PackedScene = preload("res://ui/order_viewer/order_viewer.tscn")
@onready var spaghetti: Meal = preload("res://resources/meals/spaghetti.tres")

func _ready() -> void:
	OrderBook.new_order.connect(on_new_order)

	var order = Order.new()
	order.meals.append(spaghetti)
	OrderBook.add_order(order)
	
func on_new_order(order: Order): 
	var ov = order_viewer.instantiate()
	add_child(ov)
	ov.set_order(order)
	

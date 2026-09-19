extends Node 

@export var orders: Dictionary[int, Order]
@onready var spaghetti: Meal = preload("res://resources/meals/spaghetti.tres")
var total_orders: int = 0

func _ready() -> void:
	var order = Order.new()
	order.meals.append(spaghetti)
	add_order(order)

func _process(delta: float) -> void:
	for order_id in orders:
		var order = orders[order_id]
		order.timer -= delta

func add_order(order: Order): 
	total_orders += 1

	order.id = total_orders
	order.timer = order.time

	orders[order.id] = order

func get_order(id: int):
	orders.get(id)
	
func get_orders():
	return orders

func complete_order(id: int):
	var order = orders.get(id)
	print("completed!", order.id)
	orders.erase(id)

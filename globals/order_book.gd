extends Node 

@export var orders: Dictionary[int, Order]
var total_orders: int = 0

signal new_order(order: Order)
signal orders_changed()

func _process(delta: float) -> void:
	for order_id in orders:
		var order = orders[order_id]
		order.timer -= delta

func add_order(order: Order): 
	total_orders += 1

	order.id = total_orders
	order.timer = order.time

	orders[order.id] = order
	new_order.emit(order)
	
	order.completed.connect(func(): remove_order(order.id))

func get_order(id: int):
	orders.get(id)
	
func get_orders():
	return orders

func get_parallel_order_count():
	return len(orders)

func remove_order(id: int):
	orders.erase(id)
	orders_changed.emit()

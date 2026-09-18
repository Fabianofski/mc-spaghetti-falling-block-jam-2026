extends Node 

@export var orders: Dictionary[int, Order]
var total_orders: int = 0

func _ready() -> void:
    orders = { 0: Order.new()}

func _process(delta: float) -> void:
    for order_id in orders:
        var order = orders[order_id]
        order.timer -= delta

func add_order(order: Order): 
    total_orders += 1

    order.id = total_orders
    order.timer = order.time

    orders[order.id] = order

func get_order(id: String):
    orders.get(id)
    
func get_orders():
    return orders
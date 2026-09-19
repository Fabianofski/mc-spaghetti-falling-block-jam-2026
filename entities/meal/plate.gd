extends Node2D
class_name Plate

var order: Order

func _ready() -> void:
    SignalBus.add_meal_to_order.connect(add_meal_to_order)

func add_meal_to_order(order_id: int, meal_id: String):
    if order == null:
        order = OrderBook.get_orders().get(order_id)

    if order.id != order_id: 
        return
    
    var order_complete = order.meals.all(func(m): return m.completed)
    if order_complete:
        OrderBook.complete_order(order.id)
        order = null
        
            
        
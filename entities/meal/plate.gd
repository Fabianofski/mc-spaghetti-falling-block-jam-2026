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

    var checked_order = false
    var meal_complete = true
    for meal in order.meals:
        if meal.completed: continue
        if not checked_order and meal.id == meal_id:
            meal.completed = true
            checked_order = true
        else:
            meal_complete = false
        
    print("Meal Completed: ", meal_complete)
    if meal_complete:
        OrderBook.complete_order(order.id)
        order = null
        
            
        
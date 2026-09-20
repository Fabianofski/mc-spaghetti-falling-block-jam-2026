extends Node2D 
class_name OrderGenerator

@onready var timer: Timer = $OrderTimer

func _ready() -> void:
    timer.timeout.connect(create_order)
    timer.start()

func create_order(): 
    var day = GameManager.get_day()

    if OrderBook.total_orders >= day.total_orders: 
        return
    
    if OrderBook.get_parallel_order_count() >= day.max_parallel_orders:
        timer.start()
        return
    print("Create Order")

    var order = Order.new()
    var total_meals = randi_range(1, day.meals_per_order)
    for _i in total_meals:
        var meal_idx = randi_range(0, len(day.available_meals) - 1)
        var meal = day.available_meals[meal_idx].duplicate()
        order.meals.append(meal)
    order.time = day.time_per_order
    
    OrderBook.add_order(order)
    timer.start()

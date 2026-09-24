extends Node2D 
class_name OrderGenerator

@onready var timer: Timer = $OrderTimer

func _ready() -> void:
	timer.timeout.connect(create_order)
	var day = GameManager.get_day()
	day.state_changed.connect(func(state): if state == Day.DayState.InProgress: timer.start())

func create_order(): 
	var day = GameManager.get_day()
	
	if day.state != Day.DayState.InProgress:
		return

	if OrderBook.total_orders >= day.total_orders: 
		return
	
	if OrderBook.get_parallel_order_count() >= day.max_parallel_orders:
		timer.start()
		return

	var order = Order.new()
	var total_meals = randi_range(1, day.meals_per_order)
	for _i in total_meals:
		var meal_idx = randi_range(0, len(day.available_meals) - 1)
		var meal = day.available_meals[meal_idx].duplicate()
		order.meals.append(meal)
	order.time = day.time_per_order + GameManager.upgrades.order_time * 5 # + 5 seconds with every upgrade
	
	OrderBook.add_order(order)
	timer.start()

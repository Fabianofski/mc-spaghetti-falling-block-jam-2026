extends Node2D 
class_name OrderGenerator

@export var days: Array[Day]
@onready var timer: Timer = $OrderTimer

var total_orders: int = 0
var finished_orders: int = 0

func _ready() -> void:
	timer.timeout.connect(create_order)
	timer.start()
	
	OrderBook.orders_changed.connect(check_day_end_condition)

func get_current_day():
	var idx = min(GameManager.get_day(), len(days)-1)
	return days[idx]

func check_day_end_condition():
	var day = get_current_day()

	finished_orders += 1
	if finished_orders >= day.total_orders:
		SignalBus.day_finished.emit()
	

func create_order(): 
	var day = get_current_day()
	
	if OrderBook.get_parallel_order_count() >= day.max_parallel_orders:
		timer.start()
		return

	if total_orders >= day.total_orders: 
		return

	var order = Order.new()
	var total_meals = randi_range(1, day.meals_per_order)
	for _i in total_meals:
		var meal_idx = randi_range(0, len(day.available_meals) - 1)
		var meal = day.available_meals[meal_idx].duplicate()
		order.meals.append(meal)
	order.time = day.time_per_order
	
	OrderBook.add_order(order)
	total_orders += 1
	timer.start()

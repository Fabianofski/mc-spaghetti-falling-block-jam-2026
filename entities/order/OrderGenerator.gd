extends Node2D 
class_name OrderGenerator

@export var days: Array[Day]
@export var current_day_idx: int
@onready var timer: Timer = $OrderTimer

var total_orders: int = 0

func _ready() -> void:
	timer.timeout.connect(create_order)
	timer.start()

func get_current_day():
	return days[current_day_idx]

func create_order(): 
	var day = get_current_day()
	
	if OrderBook.get_parallel_order_count() >= day.max_parallel_orders:
		timer.start()
		return

	if total_orders >= day.total_orders: 
		return
	print("ORDER!!!!")

	var meal_idx = randi_range(0, len(day.available_meals) - 1)
	var meal = day.available_meals[meal_idx]
	
	var order = Order.new()
	order.meals.append(meal)
	order.time = day.time_per_order
	
	OrderBook.add_order(order)
	total_orders += 1
	timer.start()

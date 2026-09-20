extends Node 

var orders: Dictionary[int, Order]
var finished_orders: Dictionary[int, Order]

var total_orders: int = 0

signal new_order(order: Order)
signal order_finished()

func reset_orders():
    orders = {}
    finished_orders = {}
    total_orders = 0

func _process(delta: float) -> void:
    var day = GameManager.get_day()
    if day.state != Day.DayState.InProgress: return
    for order_id in orders:
        var order = orders.get(order_id)
        if order: order.update_timer(delta)

func add_order(order: Order): 
    total_orders += 1

    order.id = total_orders
    order.timer = order.time

    orders[order.id] = order
    new_order.emit(order)
    
    order.completed.connect(func(): finish_order(order.id))
    order.failed.connect(fail_day)

func get_order(id: int):
    orders.get(id)
    
func get_orders():
    return orders

func get_parallel_order_count():
    return len(orders)

func fail_day():
    var day = GameManager.get_day()
    day.fail()

func finish_order(id: int):
    var order = orders.get(id) 
    finished_orders[id] = order
    orders.erase(id)
    order_finished.emit()
    
    var day = GameManager.get_day()
    day.add_max_score(order.calc_max_score())
    day.add_score(order.calc_score())
    if len(finished_orders) >= day.total_orders:
        day.success()

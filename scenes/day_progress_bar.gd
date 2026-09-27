extends ProgressBar

func _ready() -> void:
	OrderBook.order_finished.connect(update_progress)
	
func update_progress():
	value = OrderBook.finished_orders.size() / float(GameManager.get_day().total_orders)
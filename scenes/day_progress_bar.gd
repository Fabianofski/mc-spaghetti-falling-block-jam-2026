extends ProgressBar

func _ready() -> void:
	OrderBook.order_finished.connect(update_progress)
	
func update_progress():
	var tween: Tween
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	tween.tween_property(self, "value", OrderBook.finished_orders.size() / float(GameManager.get_day().total_orders), 0.5)
	await tween.finished
	tween.kill()

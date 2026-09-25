extends Control

@onready var billing_position: PackedScene = preload("res://ui/billing/position.tscn")
@onready var positions: Node = $Positions

func _ready() -> void:
	var day = GameManager.get_day()
	day.completed.connect(create_billing)
	
func create_billing():
	var day = GameManager.get_day()
	var total_earning = 0
	
	for o_id in OrderBook.finished_orders:
		var o = OrderBook.finished_orders.get(o_id)
		var meals: String = "Order %d:" % o_id
		for m in o.meals:
			meals += "\n" + m.name
		var pos = billing_position.instantiate()
		positions.add_child(pos)
		pos.set_billing_position(meals, o.calc_score())
		total_earning += o.calc_score()

	var line = billing_position.instantiate()
	positions.add_child(line)
	line.set_billing_position("---------", 0)
	
	var total = billing_position.instantiate()
	positions.add_child(total)
	total.set_billing_position("Total", total_earning)

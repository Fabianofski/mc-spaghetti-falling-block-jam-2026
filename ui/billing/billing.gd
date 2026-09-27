extends Control

@onready var billing_position: PackedScene = preload("res://ui/billing/position.tscn")
@onready var positions: Node = $Positions
@onready var total: Label = $Positions/Total
@onready var header: Label = $Positions/Header

func _ready() -> void:
	var day = GameManager.get_day()
	day.completed.connect(create_billing)

func create_billing() -> void:
	var summary: Dictionary = {}
	var total_earning: int = 0
	var total_orders: int = OrderBook.finished_orders.size()

	for o_id in OrderBook.finished_orders:
		var o = OrderBook.finished_orders.get(o_id)
		var score_per_meal = o.calc_score() / max(1, o.meals.size())

		for m in o.meals:
			if not summary.has(m.name):
				summary[m.name] = {"count": 0, "earnings": 0}
			
			summary[m.name]["count"] += 1
			summary[m.name]["earnings"] += score_per_meal

		total_earning += o.calc_score()
		
	var expenses = GameManager.get_day().expenses
	for expense_name in expenses:
		var expense = expenses.get(expense_name)
		summary[expense_name] = { 
			"count": 1,
			"earnings": -expense
		}
		total_earning -= expense

	header.text = "Total Orders: %d" % total_orders
	animate_entry(header, 0)

	var index: int = 1
	for meal_name in summary:
		var item = summary[meal_name]
		var pos = billing_position.instantiate()
		positions.add_child(pos)
		positions.move_child(pos, index)
		
		pos.set_billing_position("%s (x%d)" % [meal_name, item["count"]], item["earnings"])
		animate_entry(pos, index)
		index += 1

	total.text = "Total: £%d" % total_earning
	animate_entry(total, index)

func animate_entry(node: Control, index: float) -> void:
	var tween = create_tween().set_parallel(true)
	node.offset_transform_enabled = true
	node.offset_transform_position.x -= 40
	node.modulate.a = 0.0
	tween.tween_property(node, "offset_transform_position:x", node.offset_transform_position.x + 40.0, 0.4)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT).set_delay(index * 0.4)
	tween.tween_property(node, "modulate:a", 1.0, 0.4)\
		.set_delay(index * 0.4)

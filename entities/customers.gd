extends Node2D

@onready var puppet: PackedScene = preload("res://scenes/puppet.tscn")
@onready var earning: PackedScene = preload("res://ui/earning.tscn")
@export var parent: Node

var puppets: Array[Node] = []

func _ready() -> void:
	OrderBook.new_order.connect(add_customer)
	
func add_customer(order: Order):
	var p = puppet.instantiate()
	add_child(p)
	p.play_anim()
	
	p.scale = Vector2.ONE * 1.5
	puppets.append(p)
	
	order.completed.connect(func(): p.play_anim("order_done"))
	order.completed.connect(func(): puppets.erase(p))
	order.completed.connect(func(): show_earnings(p, order.calc_score()))
	
	arrange_puppets()

func arrange_puppets():
	for i in len(puppets):
		var p = puppets[i]
		p.position.x = i * 150
		
func show_earnings(puppet: Node, earnings: int):
	var e = earning.instantiate()
	e.text = "₤%d" % [earnings]
	e.global_position = puppet.global_position
	e.position.y -= 400
	parent.add_child(e)
	

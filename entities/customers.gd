extends Node2D

@onready var puppet: PackedScene = preload("res://scenes/puppet.tscn")
var puppets: Array[Node] = []

func _ready() -> void:
	OrderBook.new_order.connect(add_customer)
	
func add_customer(order: Order):
	var p = puppet.instantiate()
	add_child(p)
	
	p.scale = Vector2.ONE * 1.5
	puppets.append(p)
	
	order.completed.connect(func(): p.queue_free())
	order.completed.connect(func(): puppets.erase(p))
	
	arrange_puppets()

func arrange_puppets():
	for i in len(puppets):
		var p = puppets[i]
		p.position.x = i * 100

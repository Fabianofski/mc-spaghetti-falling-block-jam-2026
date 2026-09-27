extends Node2D

@onready var puppet: PackedScene = preload("res://entities/puppets/puppet.tscn")
@onready var earning: PackedScene = preload("res://ui/earning.tscn")
@export var parent: Node

var scripted_appearance: Array[ScriptedAppearance] = []

var puppets: Array[Puppet] = []

func _ready() -> void:
	for scripted_file in ResourceLoader.list_directory("res://resources/scripted_appearances"):
		var scripted_path = "res://resources/scripted_appearances/" + scripted_file
		var scripted = ResourceLoader.load(scripted_path)
		scripted_appearance.append(scripted)
	OrderBook.new_order.connect(add_customer)
	
func add_customer(order: Order):
	var p = puppet.instantiate()
	add_child(p)
	p.play_anim()
	
	p.scale = Vector2.ONE * 1.5
	puppets.append(p)
	
	for scripted in scripted_appearance:
		if GameManager.get_day().day == scripted.day:
			if OrderBook.total_orders == scripted.no_customer:
				p.override_sprite(scripted.sprite)
	
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
	

extends Node2D
class_name Plate

@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var audio: AudioStreamPlayer2D = $PlateSound

var order: Order

func _ready():
	OrderBook.new_order.connect(add_order)

func add_order(_order: Order):
	order = _order
	for m in order.meals:
		m.completed.connect(_spoof_out_clouds)

func _spoof_out_clouds(): 
	audio.play()
	particles.emitting = true

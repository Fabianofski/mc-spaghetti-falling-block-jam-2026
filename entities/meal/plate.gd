extends Node2D
class_name Plate

@onready var particles: GPUParticles2D = $GPUParticles2D

var order: Order

func _ready() -> void: SignalBus.done_cooking.connect(_spoof_out_clouds)

func set_order(_order):
	order = _order

func _spoof_out_clouds(): particles.emitting = true

extends Node

@export_range(1, 48, 1) var puppet_count: int
@export_range(0, 1280, 1) var y_position: int

const PUPPET = preload("uid://b4sn3d3wmss2s")

func _ready() -> void:
	for count in range(puppet_count):
		var puppet_instance: Node2D = PUPPET.instantiate()
		if randi_range(0, 1) == 0: puppet_instance.movement_dir = "Left"
		else: puppet_instance.movement_dir = "Right"
		puppet_instance.global_position.y = y_position
		match puppet_instance.movement_dir:
			"Right":
				puppet_instance.global_position.x = -256
			_:
				puppet_instance.global_position.x = 1536
		if count > 0: puppet_instance.wait_time = randf_range(0.0, 40.0)
		add_child(puppet_instance)

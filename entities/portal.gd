extends Area2D
class_name Portal

@export var spawnPos: Vector2

func _ready() -> void:
	body_entered.connect(on_body_entered)
	
func on_body_entered(body: Node2D) -> void:
	body.global_position.y = spawnPos.y

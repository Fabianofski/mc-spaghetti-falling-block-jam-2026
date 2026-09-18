extends CharacterBody2D
class_name IngredientBlock

@export var id: String
var gravity = 15000.0

func _physics_process(delta: float) -> void:
    if not is_on_floor():
            velocity.y = gravity * delta
    move_and_slide()
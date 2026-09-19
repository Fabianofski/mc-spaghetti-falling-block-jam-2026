extends CharacterBody2D
class_name IngredientBlock

var id: String
var gravity = 15000.0

var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
    input_pickable = true

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if event.pressed:
            is_dragging = true
            drag_offset = global_position - get_global_mouse_position()

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if not event.pressed:
            is_dragging = false

func _physics_process(delta: float) -> void:
    if is_dragging:
        global_position = get_global_mouse_position() + drag_offset
        return

    if not is_on_floor():
            velocity.y = gravity * delta
    move_and_slide()
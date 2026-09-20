extends CharacterBody2D
class_name IngredientBlock

static var currently_dragged: IngredientBlock = null

var id: String
var gravity = 15000.0
var drag_speed = 20.0

var is_dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

var last_position: Vector2 = Vector2.ZERO
var scale_tween: Tween 

@onready var sprite: Sprite2D = $Sprite2D

@onready var grab_sound = $GrabSound
@onready var grab_release_sound = $GrabReleaseSound

func _ready() -> void:
    input_pickable = true
    
func set_texture(tex: Texture): 
    var mat = sprite.material.duplicate()
    mat.set_shader_parameter("image", tex)
    sprite.material = mat

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if event.pressed and currently_dragged == null:
            currently_dragged = self
            grab_sound.play()
            is_dragging = true
            drag_offset = global_position - get_global_mouse_position()
            last_position = global_position 
            _apply_bouncy_scale(Vector2(0.6, 0.6))

func _input(event: InputEvent) -> void:
    if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
        if not event.pressed and currently_dragged == self:
            currently_dragged = null
            is_dragging = false
            grab_release_sound.play()
            _apply_bouncy_scale(Vector2(0.5, 0.5))

func _apply_bouncy_scale(target_scale: Vector2) -> void:
    if scale_tween and scale_tween.is_running():
        scale_tween.kill()
        
    scale_tween = create_tween()
    scale_tween.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
    scale_tween.tween_property(sprite, "scale", target_scale, 0.6)

func _physics_process(delta: float) -> void:
    if is_dragging:
        var new_pos = get_global_mouse_position() + drag_offset
        global_position = lerp(global_position, new_pos, drag_speed * delta)
        
        var x_movement = global_position.x - last_position.x
        
        var target_rotation = x_movement * 0.05
        sprite.rotation = lerp(sprite.rotation, target_rotation, 15.0 * delta)
        
        last_position = global_position
        return

    sprite.rotation = lerp(sprite.rotation, 0.0, 10.0 * delta)

    if not is_on_floor():
        velocity.y = gravity * delta
    velocity.x = 0
    move_and_slide()
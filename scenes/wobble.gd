extends Node2D

var constant_offset_time: float = 0.0
var random_offset: float = 0.0
const ANIM_TIME: float = 0.3

func _ready() -> void:
    random_offset = randf()

func _process(delta: float) -> void:
    var offset: float = (sin(constant_offset_time * ANIM_TIME) * 0.15) - (random_offset / 16)
    constant_offset_time += delta + (random_offset / 8)
    rotation = offset
    position += Vector2(-offset, -offset / 4)
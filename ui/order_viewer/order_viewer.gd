extends Control 
class_name OrderViewer

var order: Order 
@onready var meals: VBoxContainer = $Meals
@onready var meal_viewer: PackedScene = preload("res://ui/order_viewer/meal_viewer/meal_viewer.tscn")
@onready var time_left : ProgressBar = $TimeLeft
@onready var time_left_percentage: Label = $TimeLeft/Label
@onready var sprite: TextureRect = $Sprite
var _tween: Tween = null

var completed: bool = false

func on_order_completed(): 
	completed = true
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel()
	_tween.tween_property(self, "modulate", Color(0.67, 0.67, 0.67, 0.0), 0.25)
	_tween.tween_property(self, "global_position", Vector2(global_position.x, global_position.y + 16), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	await _tween.finished
	_tween.kill()
	queue_free()

func set_order(_order: Order):
	order = _order
	order.completed.connect(on_order_completed)

	for idx in len(order.meals): 
		var meal = order.meals[idx]
		var mv = meal_viewer.instantiate()
		meals.add_child(mv)
		mv.set_meal(meal)

	self.global_position.y += randf_range(-8, 8) # NOTE: Doesn't work for some reason...

	sprite.self_modulate = Color.YELLOW
	sprite.scale = Vector2(0.55, 0.55)
	if _tween: _tween.kill()
	_tween = create_tween().set_parallel()
	_tween.tween_property(sprite, "self_modulate", Color.WHITE, 0.5)
	_tween.tween_property(sprite, "scale", Vector2(0.5, 0.5), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUART)
	await _tween.finished
	_tween.kill()

func _process(_delta: float) -> void:
	if not completed: time_left.value = order.timer / order.time
	
	if time_left.value > 0: time_left_percentage.text = str(int(time_left.value * 100)) + "%"
	else: time_left_percentage.text = "MISSED"
	
	if time_left.value < 0.25 and not time_left.indeterminate: time_left.indeterminate = true

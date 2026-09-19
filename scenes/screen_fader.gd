extends CanvasLayer

@onready var fade: ColorRect = $ColorRect

func change_scene(path: String) -> void:
	
	var tween: Tween = create_tween()
	tween.tween_method(
		func(value): fade.material.set_shader_parameter("height", value),
		-1.0, 1.0, 0.5)
	await tween.finished
	
	match path:
		"RELOAD": get_tree().reload_current_scene()
		"QUIT": get_tree().quit()
		_: get_tree().change_scene_to_file(path)
	
	if tween: tween.kill()
	fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tween = create_tween()
	tween.tween_method(
		func(value): fade.material.set_shader_parameter("height", value),
		1.0, -1.0, 0.5)
	await tween.finished

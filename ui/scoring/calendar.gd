extends GridContainer
class_name Calendar

@onready var day_prefab: PackedScene = preload("res://ui/scoring/day.tscn")

func create_calendar(days: Array[Day]):
	for day in days:
		var prefab = day_prefab.instantiate()
		var day_label: Label = prefab.get_node("DayLabel")
		var day_grade: Label = prefab.get_node("DayGrade")
		
		day_label.text = "Day %d" % [day.day]
		add_child(prefab)

		if day.state == Day.DayState.Success:
			prefab.self_modulate = Color("b38c56")

		if day.state == Day.DayState.Open:
			day_grade.text = ""
			day_label.modulate = Color(0.5, 0.5, 0.5, 1.0)
		else:
			day_grade.text = day.get_grade()
			day_label.modulate = Color.WHITE

		if day.day == GameManager.get_day().day:
			_animate_grade(day_grade)


func _animate_grade(grade_label: Label) -> void:
	grade_label.pivot_offset = grade_label.size / 2.0
	grade_label.scale = Vector2.ZERO
	grade_label.modulate.a = 0.0

	var tween = create_tween().set_parallel(true)
	tween.tween_property(grade_label, "scale", Vector2.ONE, 0.4)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	tween.tween_property(grade_label, "modulate:a", 1.0, 0.3)

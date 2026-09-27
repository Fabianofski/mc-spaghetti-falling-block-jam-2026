extends Node

@onready var label: Label = $Label
var day: Day 

func _ready() -> void:
	day = GameManager.get_day()
	label.text = "Day %d · ₤%d" % [day.day, 0]
	day.score_changed.connect(update_score)

func update_score(score: int):
	label.text = "Day %d · ₤%d" % [day.day, score]

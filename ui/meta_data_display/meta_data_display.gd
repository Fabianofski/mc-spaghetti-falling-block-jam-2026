extends Node

@onready var day_label: Label = $DayLabel 
@onready var score_label: Label = $ScoreLabel
var day: Day 

func _ready() -> void:
	day = GameManager.get_day()
	day_label.text = "Day %d" % [day.day]
	day.score_changed.connect(update_score)

func update_score(score: int):
	score_label.text = "₤%d" % [GameManager.money + score]

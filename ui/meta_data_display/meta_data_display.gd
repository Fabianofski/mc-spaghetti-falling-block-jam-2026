extends Node

@onready var day_label: Label = $DayLabel 
@onready var score_label: Label = $ScoreLabel

func _ready() -> void:
    day_label.text = "Day %d" % [GameManager.get_day() + 1]

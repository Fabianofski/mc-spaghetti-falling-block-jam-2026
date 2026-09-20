extends Control

@onready var calendar: Calendar = $Calendar

func _ready() -> void:
    var day = GameManager.get_day() as Day
    day.completed.connect(calc_score)
    
func calc_score(): 
    var days = GameManager.days
    calendar.create_calendar(days)
    

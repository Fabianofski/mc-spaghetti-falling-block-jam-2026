extends GridContainer
class_name Calendar

@onready var day_prefab: PackedScene = preload("res://ui/scoring/day.tscn")

func create_calendar(days: Array[Day]):
    for day in days:
        var prefab = day_prefab.instantiate()
        prefab.get_node("DayLabel").text = "Day %d" % [day.day]
        prefab.get_node("DayGrade").text =  day.get_grade() if day.state != Day.DayState.Open else ""
        add_child(prefab)

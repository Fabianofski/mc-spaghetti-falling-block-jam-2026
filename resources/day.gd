extends Resource
class_name Day 

@export var day: int
@export var available_meals: Array[Meal]
@export var total_orders: int 
@export var meals_per_order: int
@export var time_per_order: float
@export var max_parallel_orders: int
@export var dialogue: Array[Dialogue]
var dialogue_played: bool = false

signal score_changed(score: int)
var score: int = 0
var max_score: int = 0

enum DayState { Open, InProgress, Failed, Success}
var state: = DayState.Open
signal state_changed(state: DayState)
signal completed()
signal succeeded()
signal failed()

func reset(): 
	score = 0
	max_score = 0
	state = DayState.Open
	
func success():
	state = DayState.Success
	state_changed.emit(state)
	succeeded.emit()
	completed.emit()
	
func fail():
	state = DayState.Failed
	state_changed.emit(state)
	failed.emit()
	completed.emit()
	
func start():
	state = DayState.InProgress
	state_changed.emit(state)

func add_score(add: int):
	score += add
	score_changed.emit(score)
	
func add_max_score(add: int):
	max_score += add

func get_grade_from_percentage(percentage: float) -> String:
	var grades = [
		{"threshold": 0.97, "grade": "A+"},
		{"threshold": 0.93, "grade": "A"},
		{"threshold": 0.90, "grade": "A-"},
		{"threshold": 0.87, "grade": "B+"},
		{"threshold": 0.83, "grade": "B"},
		{"threshold": 0.80, "grade": "B-"},
		{"threshold": 0.77, "grade": "C+"},
		{"threshold": 0.73, "grade": "C"},
		{"threshold": 0.70, "grade": "C-"},
		{"threshold": 0.67, "grade": "D+"},
		{"threshold": 0.63, "grade": "D"},
		{"threshold": 0.60, "grade": "D-"},
	]
	
	for grade_entry in grades:
		if percentage >= grade_entry.threshold:
			return grade_entry.grade
	
	return "F"

func get_grade() -> String: 
	if state == DayState.Failed: return "F"
	var percentage = score / float(max_score)
	var grade = get_grade_from_percentage(percentage)
	return grade
	

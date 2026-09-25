extends Resource
class_name Order

@export var id: int 
@export var time: float
@export var meals: Array[Meal]
var timer: float 

signal updated()
signal completed()
signal failed()

func check_completion():
	if meals.all(func(m): return m.complete):
		complete_order()

func needs_ingredients(available: Array[IngredientBlock]):
	for idx in len(meals):
		var meal = meals[idx]
		if meal.complete: continue 
		if meal.recipe_correct(available):
			return idx
	return -1

func complete_meal(meal_idx: int):
	var meal = meals[meal_idx]
	meal.complete_meal()
	check_completion()
	
func complete_order():
	updated.emit()
	completed.emit()
	
func calc_max_score() -> int: 
	var score = 0 
	for meal in meals: 
		score += meal.calc_score()
	return score * 100
	
func calc_score() -> int:
	var time_factor = min(1, timer / (time * 0.6)) # Finishing Order with 60% time left is A+ Score
	return calc_max_score() * time_factor

func update_timer(delta: float):
	timer -= delta
	if timer <= 0:
		timer = 0
		failed.emit()

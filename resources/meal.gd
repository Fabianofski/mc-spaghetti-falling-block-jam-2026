extends Resource
class_name Meal

signal meal_completed()

func complete_meal():
    meal_completed.emit()
    completed = true

@export var id: String
@export var name: String
@export var ingredients: Array[Ingredient]
var completed: bool
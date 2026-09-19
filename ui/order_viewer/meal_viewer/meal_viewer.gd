extends Node
class_name MealViewer

var meal: Meal
@onready var meal_label: Label = $MealLabel
@onready var ingredient_label: Label = $IngredientLabel

func format_ingredients(accum: String, i: Ingredient) -> String:
    return accum + i.name + "\n"

func set_meal(order_id: int, _meal: Meal): 
    meal = _meal
    meal_label.text = "#%d %s" % [order_id, meal.name]
    ingredient_label.text = meal.ingredients.reduce(format_ingredients, "")
    
    meal.completed.connect(on_meal_complete)
    
func on_meal_complete():
    meal_label.text = meal_label.text + " (Done)"

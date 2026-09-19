extends Resource
class_name Meal

@export var id: String
@export var name: String
@export var ingredients: Array[Ingredient]
var complete: bool

signal completed()

func recipe_correct(available: Array[IngredientBlock]):
    if len(available) != len(ingredients):
        return false

    var available_ingredients = available.map(func(i): return i.id)
    available_ingredients.sort()
    var needed_ingredients = ingredients.map(func(i): return i.id)
    needed_ingredients.sort()

    print(available_ingredients, "==", needed_ingredients)
    return available_ingredients == needed_ingredients

func complete_meal():
    completed.emit()
    complete = true

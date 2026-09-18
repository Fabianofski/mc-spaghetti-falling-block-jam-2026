extends Area2D
class_name MealCreator

var ingredients: Array[String]

func _ready() -> void:
    body_entered.connect(on_ingredient_entered)
    body_exited.connect(on_ingredient_exited)
    
func on_ingredient_entered(ingredient: IngredientBlock):
    ingredients.append(ingredient.id)
    print(ingredients)

func on_ingredient_exited(ingredient: IngredientBlock):
    var idx = ingredients.find(ingredient.id)
    if idx != -1:
        ingredients.remove_at(idx)
    print(ingredients)

func recipe_is_correct(meal: Meal) -> bool:
    if len(ingredients) != len(meal.ingredients):
        return false
    return true

func create_meal(): 
    var orders = OrderBook.get_orders()

    for order in orders: 
        for meal in order.meals:
            if meal.completed:
                continue

            if recipe_is_correct(meal):
                meal.completed = true
                break;

    ingredients = []

    
extends Area2D
class_name MealCreator

var ingredients: Array[IngredientBlock]
var cooking: bool = false
@onready var timer: Timer = $CookTimer
@onready var progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
    body_entered.connect(on_ingredient_entered)
    body_exited.connect(on_ingredient_exited)
    
    timer.timeout.connect(finish_meal)
    
func _process(_delta: float) -> void:
    progress_bar.value = 1 - timer.time_left / timer.wait_time
    
func on_ingredient_entered(ingredient: Node):
    if ingredient is IngredientBlock:
        ingredients.append(ingredient)

func on_ingredient_exited(ingredient: Node):
    if ingredient is IngredientBlock:
        var idx = ingredients.find(ingredient)
        if idx != -1:
            ingredients.remove_at(idx)

func recipe_is_correct(meal: Meal) -> bool:
    if len(ingredients) != len(meal.ingredients):
        return false
    return true

func create_meal():
    if (cooking): return

    print("Cooking")
    cooking = true
    timer.start()
        
func finish_meal(): 
    var orders = OrderBook.get_orders()
    for order_id in orders:
        var order = orders[order_id]

        var meal_idx = order.needs_ingredients(ingredients)
        if meal_idx != -1: 
            order.complete_meal(meal_idx)
            break

    for i in ingredients:
        i.queue_free()

    cooking = false
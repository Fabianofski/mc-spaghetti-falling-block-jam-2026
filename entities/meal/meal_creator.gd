extends Area2D
class_name MealCreator

var ingredients: Array[IngredientBlock]
var cooking: bool = false
@onready var timer: Timer = $CookTimer

func _ready() -> void:
	body_entered.connect(on_ingredient_entered)
	body_exited.connect(on_ingredient_exited)
	
	timer.timeout.connect(func(): cooking = false)
	
func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_C):
		create_meal()
	
func on_ingredient_entered(ingredient: IngredientBlock):
	ingredients.append(ingredient)

func on_ingredient_exited(ingredient: IngredientBlock):
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
	var orders = OrderBook.get_orders()

	var correct_recipe: bool = false
	for order_id in orders:
		var order = orders[order_id]

		var meal_idx = order.needs_ingredients(ingredients)
		if meal_idx != -1: 
			order.complete_meal(meal_idx)
			correct_recipe = true
			break
			
	if correct_recipe: 
		print("Correct")
	else:
		print("What is this????")

	for i in ingredients:
		i.queue_free()

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
	if Input.is_key_pressed(KEY_SPACE):
		create_meal()
	
func on_ingredient_entered(ingredient: IngredientBlock):
	ingredients.append(ingredient)
	print(ingredients)

func on_ingredient_exited(ingredient: IngredientBlock):
	var idx = ingredients.find(ingredient)
	if idx != -1:
		ingredients.remove_at(idx)
	print(ingredients)

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

	for order_id in orders:
		var order = orders[order_id]
		for meal in order.meals:
			if meal.completed: continue
			if recipe_is_correct(meal):
				print("Correct Recipe")
				meal.complete_meal()
				order.update()
				SignalBus.add_meal_to_order.emit(order.id, meal.id)
				break

	for i in ingredients:
		i.queue_free()

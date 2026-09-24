extends Area2D
class_name MealCreator

var ingredients: Array[IngredientBlock]
var cooking: bool = false
@onready var timer: Timer = $CookTimer
@onready var progress_bar: ProgressBar = $ProgressBar

@onready var pull_thingy: PullThingy = $PullThingy
var _pull_tween: Tween = null

var cancel_time: float = 0
var wait_time: float = 1

func _ready() -> void:
    body_entered.connect(on_ingredient_entered)
    body_exited.connect(on_ingredient_exited)
    
    timer.wait_time *= pow(0.5, GameManager.upgrades.cook_time) # Half with every upgrade
    wait_time = timer.wait_time 
    timer.timeout.connect(finish_meal)
    
    pull_thingy.cancelled.connect(cancel_meal)
    pull_thingy.pressed.connect(create_meal)
    
func _process(delta: float) -> void:
    if cooking:
        progress_bar.value = 1 - timer.time_left / wait_time
    else: 
        progress_bar.value = 1 - cancel_time / wait_time
        if cancel_time <= wait_time:
            cancel_time += delta
        else: 
            cancel_time = wait_time
    
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
    if (cooking): cancel_meal()

    if _pull_tween: _pull_tween.kill()
    _pull_tween = create_tween()
    _pull_tween.tween_property(pull_thingy, "position:y", -215.0, 0.45).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

    cooking = true
    timer.start()

    print("Cooking")
    
func cancel_meal():
    cooking = false
    cancel_time = timer.time_left
    timer.stop()

    print("Cancelled")
        
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

    if _pull_tween: _pull_tween.kill()
    _pull_tween = create_tween()
    _pull_tween.tween_property(pull_thingy, "position:y", -315.0, 0.45).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)

    SignalBus.done_cooking.emit()
    cooking = false
    cancel_time = wait_time

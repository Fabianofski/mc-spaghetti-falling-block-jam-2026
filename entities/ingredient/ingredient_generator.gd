extends FlowContainer

@export var ingredient_parent: Node2D
@export var rand_x: int = 50
@onready var ingredient_block = preload("res://entities/ingredient/ingredient_block.tscn")

func _ready() -> void:
	var day = GameManager.get_day()
	var needed_ingredients: Array[Ingredient] = []
	for meal in day.available_meals:
		needed_ingredients.append_array(meal.ingredients)

	for ingredient_file in ResourceLoader.list_directory("res://resources/ingredients"):
		if not ingredient_file.ends_with("tres"): continue
		var ingredient_path = "res://resources/ingredients/" + ingredient_file
		var ingredient = ResourceLoader.load(ingredient_path)

		var btn = JuicyButtonAwwYiss.new()
		add_child(btn)
		btn.text = ingredient.name
		btn.pressed.connect(generate_ingredient.bind(btn, ingredient))
		btn.custom_minimum_size = Vector2(128, 32)
		btn.disabled = needed_ingredients.find_custom(func(i): return i.id == ingredient.id) == -1
	
	OrderBook.new_order.connect(generate_order_ingredients)
	
func generate_order_ingredients(order: Order):
	for m in order.meals:
		for i in m.ingredients:
			generate_ingredient(null, i)
			await get_tree().create_timer(1).timeout
		
func generate_ingredient(btn: JuicyButtonAwwYiss, ingredient: Ingredient): 
	var i = ingredient_block.instantiate()
	ingredient_parent.add_child(i)
	i.id = ingredient.id
	i.global_position = ingredient_parent.global_position
	i.global_position.x += randi_range(-rand_x, rand_x)
	
	i.set_texture(ingredient.texture)

	if not btn: return
	btn.disabled = true
	await get_tree().create_timer(0.1).timeout
	btn.disabled = false

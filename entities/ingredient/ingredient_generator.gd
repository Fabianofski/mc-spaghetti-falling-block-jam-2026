extends FlowContainer

@export var ingredient_parent: Node2D
@export var rand_x: int = 50
@onready var ingredient_block = preload("res://entities/ingredient/ingredient_block.tscn")
@onready var buy_sound : AudioStreamPlayer2D = $BuySound
@onready var expense: PackedScene = preload("res://ui/expense.tscn")

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
		btn.pressed.connect(buy_ingredient.bind(btn, ingredient))
		btn.custom_minimum_size = Vector2(128, 32)
		btn.disabled = needed_ingredients.find_custom(func(i): return i.id == ingredient.id) == -1
	
	OrderBook.new_order.connect(generate_order_ingredients)
	
func generate_order_ingredients(order: Order):
	for m in order.meals:
		for i in m.ingredients:
			generate_ingredient(i)
			await get_tree().create_timer(1).timeout
		
func buy_ingredient(btn: JuicyButtonAwwYiss, ingredient: Ingredient): 
	var day = GameManager.get_day()
	day.add_expense("Buy: " + ingredient.name, 50)
	show_expense(btn, 50)
	buy_sound.play()
	
	generate_ingredient(ingredient)

	btn.disabled = true
	await get_tree().create_timer(0.1).timeout
	btn.disabled = false
	
func show_expense(btn: Node, expenses: int):
	var e = expense.instantiate()
	e.text = "-₤%d" % [expenses]
	e.global_position = btn.global_position
	get_parent().add_child(e)
	
func generate_ingredient(ingredient: Ingredient):
	var i = ingredient_block.instantiate()
	ingredient_parent.add_child(i)
	i.readable_name = ingredient.name
	i.id = ingredient.id
	i.global_position = ingredient_parent.global_position
	i.global_position.x += randi_range(-rand_x, rand_x)
	i.set_texture(ingredient.texture)

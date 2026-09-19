extends FlowContainer

@export var ingredients: Array[Ingredient]
@export var ingredient_parent: Node2D

func _ready() -> void:
	for ingredient in ingredients: 
		var btn = JuicyButtonAwwYiss.new()
		add_child(btn)
		btn.text = ingredient.name
		btn.pressed.connect(generate_ingredient.bind(ingredient))
		btn.custom_minimum_size = Vector2(128, 32)
		
func generate_ingredient(ingredient: Ingredient): 
	var i = ingredient.prefab.instantiate()
	ingredient_parent.add_child(i)
	i.id = ingredient.id
	i.global_position = ingredient_parent.global_position

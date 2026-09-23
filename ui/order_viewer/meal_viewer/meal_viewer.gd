extends Node
class_name MealViewer

var meal: Meal
@onready var meal_label: RichTextLabel = $MealLabel
@onready var ingredients: Node = $Ingredients


func set_meal(_meal: Meal): 
	meal = _meal
	meal_label.text = "[color=black]%s" % meal.name
	
	for i in meal.ingredients:
		var tex = TextureRect.new()
		tex.texture = i.texture
		tex.expand_mode = TextureRect.EXPAND_FIT_HEIGHT
		tex.custom_minimum_size = Vector2.ONE * 24
		ingredients.add_child(tex)
	
	meal.completed.connect(on_meal_complete)
	
func on_meal_complete():
	meal_label.text = "[i][s][color=black]%s" % meal.name
	for c in ingredients.get_children():
		c.queue_free()

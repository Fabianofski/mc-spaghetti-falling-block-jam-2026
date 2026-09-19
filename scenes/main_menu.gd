extends Control

@onready var credits: ColorRect = $Credits

func _ready() -> void:
	$"HBoxContainer/Start Button".should_oscillate = true
	$"HBoxContainer/Credits Button".should_oscillate = true
	$"HBoxContainer/Quit Button".should_oscillate = true
	credits.hide()

func _on_start_button_button_up() -> void:
	ScreenFader.change_scene("res://scenes/game.tscn")

func _on_credits_button_button_up() -> void:
	credits.show()

func _on_quit_button_button_up() -> void:
	ScreenFader.change_scene("QUIT")

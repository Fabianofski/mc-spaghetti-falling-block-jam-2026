extends Control
class_name DialogueManager

@onready var dialogue_node: Node = $Dialogue
@onready var label: Label = $Dialogue/Background/Label
@onready var character: TextureRect = $Dialogue/Character
var current_idx = 0
var tween: Tween

func _ready() -> void:
    next_dialogue()
    
func _input(event) -> void:
    var day = GameManager.get_day()
    if day.dialogue_played: return
    if event is InputEventMouseButton and event.is_pressed(): 
        if tween and tween.is_running():
            tween.stop()
            label.visible_ratio = 1
        else: 
            next_dialogue()
        
func next_dialogue(): 
    var day = GameManager.get_day()
    if day.dialogue_played or current_idx >= len(day.dialogue):
        day.start()
        dialogue_node.visible = false
        day.dialogue_played = true
        return

    var dialogue = day.dialogue[current_idx]
    character.texture = dialogue.character.avatar

    label.text = dialogue.text

    if tween: 
        tween.kill()
    tween = create_tween()
    tween.tween_method(func(i): label.visible_ratio = i, 0.0, 1.0, len(dialogue.text) / 50.0)

    if dialogue.action != "":
        SignalBus.emit_signal(dialogue.action)

    current_idx += 1

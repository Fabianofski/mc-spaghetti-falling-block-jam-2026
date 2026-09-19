extends Resource
class_name Order

var timer: float 

signal updated()
signal order_completed()

func update():
    updated.emit()
    
func complete_order():
    updated.emit()
    order_completed.emit()

@export var id: int 
@export var time: float
@export var meals: Array[Meal]


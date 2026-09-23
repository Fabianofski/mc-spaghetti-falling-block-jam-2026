extends HBoxContainer
class_name OrdersManager

@onready var order_viewer: PackedScene = preload("res://ui/order_viewer/order_viewer.tscn")

func _ready() -> void:
    OrderBook.new_order.connect(on_new_order)
    
func on_new_order(order: Order): 
    var ov = order_viewer.instantiate()
    add_child(ov)
    move_child(ov, 0)
    ov.set_order(order)
    

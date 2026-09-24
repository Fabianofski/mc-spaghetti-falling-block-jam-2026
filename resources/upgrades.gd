extends Resource
class_name Upgrades

var order_time: int = 0
var order_time_base_price: int = 100
var cook_time: int = 0
var cook_time_base_price: int = 100

func cook_time_price() -> int:
    if cook_time == 0: return cook_time_base_price
    return roundi(cook_time_base_price * pow(1.15, cook_time))

func order_time_price() -> int:
    if order_time == 0: return order_time_base_price
    return roundi(order_time_base_price * pow(1.15, order_time))
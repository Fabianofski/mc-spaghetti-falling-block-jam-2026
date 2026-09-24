extends VBoxContainer

@onready var money_label: Label = $MoneyLabel

@onready var cook_time_btn: Button = $CookTimeBtn
@onready var cook_time_label: Label = $CookTimeBtn/PriceLabel

@onready var order_time_btn: Button = $OrderTimeBtn
@onready var order_time_label: Label = $OrderTimeBtn/PriceLabel

func _ready() -> void:
	cook_time_btn.pressed.connect(buy_cook_time)
	order_time_btn.pressed.connect(buy_order_time)
	GameManager.get_day().completed.connect(init_buttons)

func init_buttons() -> void:
	cook_time_label.text = "₤%d" % GameManager.upgrades.cook_time_price()
	order_time_label.text = "₤%d" % GameManager.upgrades.order_time_price()

	cook_time_btn.disabled = GameManager.money < GameManager.upgrades.cook_time_price()
	cook_time_btn.text = "Halve cook time (%d)" % GameManager.upgrades.cook_time

	order_time_btn.disabled = GameManager.money < GameManager.upgrades.order_time_price()
	order_time_btn.text = "+5s to order time (%d)" % GameManager.upgrades.order_time
	
	money_label.text = "Your money: ₤%d" % GameManager.money
	
func buy_cook_time():
	var price = GameManager.upgrades.order_time_price()
	if GameManager.money < price:
		return
	GameManager.upgrades.cook_time += 1
	GameManager.money -= price
	init_buttons()

func buy_order_time():
	var price = GameManager.upgrades.order_time_price()
	if GameManager.money < price:
		return
	GameManager.upgrades.order_time += 1
	GameManager.money -= price
	init_buttons()

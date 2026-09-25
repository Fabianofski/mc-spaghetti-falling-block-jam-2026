extends HBoxContainer

@onready var name_label: Label = $Name
@onready var earning_label: Label = $Earning

func set_billing_position(name: String, earnings: int):
	name_label.text = name
	if earnings != 0:
		earning_label.text = "£%d" % earnings
	else:
		earning_label.text = ""

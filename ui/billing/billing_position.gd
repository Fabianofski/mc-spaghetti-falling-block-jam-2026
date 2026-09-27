extends HBoxContainer

@onready var name_label: Label = $Name
@onready var earning_label: Label = $Earning

func set_billing_position(name_text: String, earnings: int) -> void:
	name_label.text = name_text
	if earnings != 0:
		earning_label.text = "£%d" % earnings
	else:
		earning_label.text = ""

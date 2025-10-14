@tool
extends VBoxContainer

@onready var display : ControlCard  = get_node("Control_Card")
@onready var desc : Label = get_node("ScrollContainer/Descricao")
func _ready() -> void:
	desc.text = ""
func set_selected_card(card : ControlCard):
	if card == null:
		display.make_slot()
		return 1
	if not (card.disabled):
		display.make_card(card.data)
		display.reveal_ano()
		desc.text = card.data.descricao
	else:
		display.hide_ano()
		display.make_slot()
		desc.text = ""

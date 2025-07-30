@tool
class_name ControlCardHandler extends Control

@onready var slotMan : ControlSlotManager = get_node("SlotManager")
@onready var dragging_card : ControlCard = get_node("DraggingCard")

var cards_data : Array


func _ready() -> void:
	if Engine.is_editor_hint():
		cards_data = _make_fake_card_res_list(5) 
		slotMan.inserir_cartas(cards_data)


func iniciar(_cards_data : Array) -> void:
	slotMan.inserir_cartas(_cards_data)
	var all_slots : = slotMan.table_slots + slotMan.hand_slots
	all_slots.map(func (slot : ControlCard) : slot.pressed.connect(card_clicked.bind(slot)))
	dragging_card.hide()

func card_clicked(slot : ControlCard):
	print("Card clicked!!!! " + ("um slot!" if slot.is_slot() else "uma carta!"))
	dragging_card.size = slot.size
	dragging_card.show()
	

func _make_fake_card_res_list(n_cartas : int) -> Array:
	var ret := []
	var rand = RandomNumberGenerator.new()
	rand.randomize()
	for card in n_cartas:
		var r : int = rand.randi_range(0, 71) # card id
		var res : CartaRES = load("res://Resources/Cartas/"+str(r)+".res")
		ret.append(res)
	return ret

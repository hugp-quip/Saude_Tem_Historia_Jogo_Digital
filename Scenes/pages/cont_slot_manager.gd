@tool
class_name ControlSlotManager extends VBoxContainer

@onready var table : Control = get_node("Table")
@onready var hand : Control = get_node("Hand")

var hand_slots : Array # Array[ControlCartaSlot]
var table_slots : Array # Array[ControlCartaSlot]

func inserir_cartas(cartas : Array):
	var cartas_size : int = cartas.size()
	
	if cartas_size == 0 or cartas == null: push_error("Tentou criar mesa sem cartas!!!!")

	print("Criando mesa com "+ str(cartas_size) + " cartas.")
	if cartas_size > 5:
		for i in cartas_size - 5:
			table.add_child(Res.controlCardDisplay.instantiate())
			hand.add_child(Res.controlCardDisplay.instantiate())

	hand_slots = hand.get_children()
	table_slots = table.get_children() 
	
	table_slots.map( func (slot : ControlCard) : slot.make_slot() )

	for i in cartas_size:
		hand_slots[i].make_card(cartas[i])

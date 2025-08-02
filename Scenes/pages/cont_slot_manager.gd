@tool
class_name ControlSlotManager extends VBoxContainer

@onready var table : Control = get_node("Table")
@onready var hand : Control = get_node("Hand")

var hand_slots : Array # Array[ControlCartaSlot]
var table_slots : Array # Array[ControlCartaSlot]
var cartas : Array # Array[CartaRES]

func inserir_e_criar_cartas(_cartas : Array):
	cartas = _cartas
	var cartas_size : int = _cartas.size()
	
	if cartas_size == 0 or _cartas == null: push_error("Tentou criar mesa sem _cartas!!!!")

	print("Criando mesa com "+ str(cartas_size) + " cartas.")
	if cartas_size > 5:
		for i in cartas_size - 5:
			table.add_child(Res.controlCardDisplay.instantiate())
			hand.add_child(Res.controlCardDisplay.instantiate())

	hand_slots = hand.get_children()
	table_slots = table.get_children() 
	
	table_slots.map( func (slot : ControlCard) : slot.make_slot() )

	for i in cartas_size:
		hand_slots[i].make_card(_cartas[i])


func inserir_cartas(_cartas : Array):
		cartas = _cartas
		for i in _cartas.size():
			hand_slots[i].make_card(_cartas[i])


func get_correct_card_order() -> Array:
	var ret := cartas.duplicate()
	ret.sort_custom(func (c1, c2) -> bool: return c1.ano.to_int() < c2.ano.to_int())
	return ret

func is_table_full() -> bool:
	for slot in table_slots:
		if slot.is_slot():
			return false
	return true

func get_current_card_order() -> Array:
	if !is_table_full(): return []
	return table_slots

	

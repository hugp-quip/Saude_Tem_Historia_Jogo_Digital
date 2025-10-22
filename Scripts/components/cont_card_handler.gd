@tool
class_name ControlCardHandler extends Control



@onready var slotMan : ControlSlotManager = get_node("SlotManager")
@onready var cursor_card : ControlCard = get_node("DraggingCard")
var cursor_cards_original_slot : ControlCard
var is_dragging_card : = false
@export var slot_with_mouse : ControlCard 
@onready var uiHandler : PartidaUIHandler = %partida_UI_Handler
#var card_with_mouse : ControlCard 
var mouse_cardOffset : Vector2 

var cards_data : Array


func _ready() -> void:
	if Engine.is_editor_hint(): # and false:
		cards_data = _make_fake_card_res_list(5) 
		slotMan.inserir_e_criar_cartas(cards_data)


func iniciar(_cards_data : Array) -> void:
	slotMan.inserir_e_criar_cartas(_cards_data)
	var all_slots : = slotMan.table_slots + slotMan.hand_slots
	all_slots.map(func (slot : ControlCard) : 
		slot.has_mouse.connect(_update_has_mouse) 
		slot.lost_mouse.connect(_update_has_mouse)
		)
	cursor_card.hide()

func reiniciar(_cards_data : Array) -> void:
	var all_slots : = slotMan.table_slots + slotMan.hand_slots
	all_slots.map(func (slot : ControlCard) : slot.make_slot())
	slotMan.inserir_cartas(_cards_data)

var cont := 0
func _physics_process(_delta: float) -> void:
	if is_dragging_card:
		cont+=1
		if cont == 30:
			#print("dssda")
			
			cont = 0
		cursor_card.position = get_local_mouse_position() - position - mouse_cardOffset

func _update_has_mouse(slot : ControlCard):
	if slot_with_mouse != slot:
		slot_with_mouse = slot
	else:
		slot_with_mouse = null

var awaiting_dica_input := false
signal dica_card_selected(card : ControlCard)
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if awaiting_dica_input:
			if !slot_with_mouse or slot_with_mouse.is_slot():  
				uiHandler.push_info("Clique em uma carta para selecionar sua dica!") 
				return
			if slot_with_mouse.data == null: 
				push_error("De alguma forma tentou mover carta sem dados???")
				return
			awaiting_dica_input = false
			dica_card_selected.emit(slot_with_mouse)
			return
		if event.pressed:
			("pressed")
			if !slot_with_mouse: return
			if slot_with_mouse.is_slot() or not (slot_with_mouse.draggable): return
			if slot_with_mouse.data == null: push_error("De alguma forma tentou mover carta sem dados???")
			_show_cursor(slot_with_mouse)
			cursor_cards_original_slot = slot_with_mouse
			slot_with_mouse.make_slot()
		
		# released
		else:
			if is_dragging_card:
				("released")		

				_hide_cursor()
				# Não foi colocada em slot
				if slot_with_mouse == null or not (slot_with_mouse.draggable): 
					cursor_cards_original_slot.make_card(cursor_card.data)
					return

				# foi colocada em slot
				if slot_with_mouse.is_slot(): # sem carta
					slot_with_mouse.make_card(cursor_card.data)
				else: # com carta
					var temp : CartaRES = slot_with_mouse.data
					slot_with_mouse.make_card(cursor_card.data)
					cursor_cards_original_slot.make_card(temp)

			
	
func _show_cursor(card: ControlCard) -> void:
	print("a")
	is_dragging_card = true
	
	mouse_cardOffset = get_global_mouse_position() - card.global_position
	#print("Card clicked!!!! " + ("um slot!" if card.is_slot() else "uma carta!"))
	var lab : Label = card.get_node("Carta_Control_UI_Handler").get_node("ano")
	cursor_card.get_node("Carta_Control_UI_Handler").get_node("ano").add_theme_color_override("font_color", lab.get_theme_color("font_color"))
	cursor_card.get_node("Carta_Control_UI_Handler").get_node("ano").text = lab.text 
	cursor_card.size = card.size
	cursor_card.make_card(card.data)
	cursor_card.initial_position_of_drag = cursor_card.position
	cursor_card.show()
	cursor_card.is_dragging = true
	

func _hide_cursor() -> void:
	is_dragging_card = false
	cursor_card.is_dragging = true
	cursor_card.hide()
	
func _make_fake_card_res_list(n_cartas : int) -> Array:
	var ret := []
	# var rand = RandomNumberGenerator.new()
	# rand.randomize()
	# var rand = RandomNumberGenerator.new()
	# rand.randomize()
	for card in n_cartas:
		# var r : int = rand.randi_range(0, 71) # card id
		# var res : CartaRES = load("res://Resources/Cartas/"+str(r)+".res")
		#ret.append(util.random_card_res()) #res)
		# var r : int = rand.randi_range(0, 71) # card id
		# var res : CartaRES = load("res://Resources/Cartas/"+str(r)+".res")
		ret.append(util.random_card_res()) #res)
	return ret


func _on_partida_ui_handler_wants_to_select_dica() -> void:
	awaiting_dica_input = true

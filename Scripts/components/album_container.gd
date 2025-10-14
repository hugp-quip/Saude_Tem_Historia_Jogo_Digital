@tool
class_name AlbumContainer extends Control

signal switch(new:int)
@onready var layout : = %Layout
@onready var cardContainer := %Cards
@onready var cardInspector := %CardInspector
var display_cards : Array[ControlCard] = []
@onready var sair_button : Button = %sairbutton

func _ready() -> void:
	if Engine.is_editor_hint():
		var n_cards := 20
		for i in n_cards:
			var card : ControlCard = load("res://Scenes/Components/Control_Card.tscn").instantiate()
			card.criar_carta_display.call_deferred(util.random_card_res())
			card.custom_minimum_size = Vector2(170, 300)
			card.get_node("Carta_Control_UI_Handler/n_da_carta").show()
			card.get_node("Carta_Control_UI_Handler/n_da_carta").text = ( "0" + str(i) if i < 10 else str(i) )
			card.update_minimum_size()
			card.pressed.connect(_set_selected_card.bind(card.data))
			display_cards.append(card)
		_add_cards_to_display(display_cards, null)
		_set_selected_card(display_cards[0])

	_set_selected_card()

func iniciar_album_partida(correct_cards : Array[CartaRES], all_cards : Array[CartaRES], partida_state : PartidaRES) -> void:
		
		var get_pos := func (c : CartaRES) : return partida_state.baralhoINFO.cartas.find(c.id) + 1
		#print(correct_cards.map(func (c : CartaRES) : return get_pos.call(c)))
		#print(all_cards.map(func (c : CartaRES) : return get_pos.call(c)))
		all_cards.sort_custom(func (c1, c2) : return get_pos.call(c1) < get_pos.call(c2))
		#print(all_cards.map(func (c : CartaRES) : return get_pos.call(c)))
		%Data.text = partida_state.baralhoINFO.nome
		%BaralhoCompletion.text =  str(correct_cards.size()) +" / " + str(all_cards.size())
		display_cards.clear()
		
		cardContainer.get_children().map(func (c : ControlCard) : c.free() )

		var _n_card := 0
		var cor_card_first : ControlCard 
		# var cards_positions : Array[int] = []
		for card : CartaRES in all_cards:
			var card_local_id = partida_state.baralhoINFO.cartas.find(card.id) + 1
			# cards_positions.append(card_local_id - 1)
			var display_card : ControlCard = Res.controlCardDisplay.instantiate()
			display_card.custom_minimum_size = Vector2(170, 300)
			display_card.get_node("Carta_Control_UI_Handler/n_da_carta").show()
			
			display_card.get_node("Carta_Control_UI_Handler/n_da_carta").text = ( "0" + str(card_local_id) if card_local_id < 10 else str(card_local_id) )
			display_card.update_minimum_size()
			
			if card in correct_cards:
				display_card.criar_carta_display.call_deferred(card)
				display_card.pressed.connect(_set_selected_card.bind(display_card))
				display_card.reveal_ano.call_deferred()
				cor_card_first = display_card
			else:
				display_card.data = card
				display_card.disabled = true
				display_card.get_node("Carta_Control_UI_Handler/Imagem").hide()
				display_card.get_node("Carta_Control_UI_Handler/Legenda").hide()	
			display_cards.append(display_card)

			_n_card += 1
		_add_cards_to_display(display_cards, partida_state)
		
		#_set_selected_card(cor_card_first if cor_card_first != null else display_cards[0])
		

func _set_selected_card(card : ControlCard = null) -> void:
	cardInspector.set_selected_card(card)
	


func _add_cards_to_display(_cards : Array[ControlCard], _state : PartidaRES):
	# if state != null:
		
	# 	var get_pos := func (c : ControlCard) : return state.baralhoINFO.cartas.find(c.data.id)+1
		
	# 	print(_cards.map(func (c : ControlCard) : return get_pos.call(c)))
	# 	_cards.sort_custom(func (c1, c2) : return get_pos.call(c1) < get_pos.call(c2))
	# 	print(_cards.map(func (c : ControlCard) : return get_pos.call(c)))
	for c in _cards:
		cardContainer.add_child(c)
	
func _on_sairbutton_pressed() -> void:
	switch.emit(G.M.SELECT)	

extends Control

signal switch(new:int, data : Dictionary)

var rodadaCont : RodadaCont 
var uiHandler : PartidaUIHandler 
var baralhoHandler : BaralhoHandler
var albumCont : AlbumContainer
var state : PartidaRES



# func _ready() -> void:
# 	#print(criar_partida.get_method())#.get_basename())

func criar_partida(_partida: PartidaRES) -> void:
	state = _partida

func _ready() -> void:
	rodadaCont = get_node("GameplayDiv/RodadaCont")
	uiHandler = get_node("GameplayDiv/partida_UI_Handler")
	baralhoHandler  = get_node("BaralhoHandler")
	albumCont = %AlbumContainer
	albumCont.sair_button.pressed.connect(_on_album_sair_button_pressed)
	updateUI(state)
	
	rodadaCont.finished_with_win.connect(_on_finished_rodada)
	rodadaCont.needs_update_ui.connect(updateUI)

	baralhoHandler.comecar(state.baralhoINFO, state.n_rodadas, state.n_cartas)
	rodadaCont.criar_primeira_rodada(state, baralhoHandler.criar_hand_para_partida())
	get_node("GameplayDiv/partida_UI_Handler/Side_Panel/VBoxContainer/Icon").texture = state.baralhoINFO.imagem
	
func updateUI(_state : PartidaRES) -> void:
	uiHandler.update(_state)
	#util.stop()

func _on_finished_rodada(win : bool) -> void:
	print("win: ", win)
	if win:
		state.rodadas.append(rodadaCont.rodada_state)
		self.state.rodada_atual += 1

		if self.state.rodada_atual > self.state.n_rodadas:
			#self.state.rodada_atual -= 2
			uiHandler.show_final(state, win)
			salvar_resultado_to_album_at_end()
			return 
		
		uiHandler.enviar_rodada_to_proxima_rodada(state, new_rodada)
		salvar_resultado_to_album()	
	else: # defeat
		uiHandler.show_final(state, win)
		state.album.performances.append(state.points)
	
	updateUI(state)

func salvar_resultado_to_album_at_end():
	state.album.performances.append(state.points)
	save_most_recent_rodada_correct_cards()

func salvar_resultado_to_album():
	save_most_recent_rodada_correct_cards()

func save_most_recent_rodada_correct_cards():
	var alb_complete : Array[int] = state.album.completedCartas
	for carta_id : int in state.rodadas[-1].correct_cards.map(func (c : CartaRES) : return c.id):
		if not (carta_id in alb_complete):
			alb_complete.append(carta_id)


func new_rodada(partida_state: PartidaRES, reverter_estado_do_envio : Callable):
	rodadaCont._criar_rodada(partida_state, baralhoHandler.criar_hand_para_partida())
	reverter_estado_do_envio.bind(new_rodada).call()

func _on_pausa_but_pressed() -> void:
	uiHandler.switch_pause()


func _on_resumir_pressed() -> void:
	_on_pausa_but_pressed()


func _on_reiniciar_pressed() -> void:
	switch.emit(G.M.JOGAR, state.baralhoINFO, state.album)

func _on_sair_pressed() -> void:
	switch.emit(G.M.SELECT)


func _on_album_button_pressed() -> void:
	baralhoHandler.load_all_baralho_to_cache(state)
	var _correct_cards : Array[CartaRES] = baralhoHandler.load_cards_in_album_to_cache(state)
	uiHandler.switch_pause_button();
	albumCont.iniciar_album_partida(_correct_cards, baralhoHandler.cartaRESCache, state)
	albumCont.show()

func _on_album_sair_button_pressed() -> void:
	albumCont.hide()
	uiHandler.switch_pause_button()


func _dica_usada() -> void:
	state.dicas_usadas += 1
	uiHandler.update(state)

func can_dica() -> bool:
	return state.dicas_usadas < state.n_dicas

func _on_descricao_but_pressed() -> void:
	if !can_dica(): 
		uiHandler.push_info_timer("Você não tem mais dicas!")
		return
	
	_dica_usada()
	uiHandler._on_descricao_but_pressed()

func _on_dica_but_pressed() -> void:
	if !can_dica(): 
		uiHandler.push_info_timer("Você não tem mais dicas!")
		return
	
	_dica_usada()
	uiHandler._on_dica_but_pressed()

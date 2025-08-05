extends Control

signal switch(new:int, data : Dictionary)

var rodadaCont : RodadaCont 
var uiHandler : PartidaUIHandler 
var baralhoHandler : BaralhoHandler 
var state : PartidaRES

# func _ready() -> void:
# 	#print(criar_partida.get_method())#.get_basename())

func criar_partida(_partida: PartidaRES) -> void:
	state = _partida

func _ready() -> void:
	rodadaCont = get_node("GameplayDiv/RodadaCont")
	uiHandler = get_node("GameplayDiv/partida_UI_Handler")
	baralhoHandler  = get_node("BaralhoHandler")
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
	if win:
		self.state.rodada_atual += 1
		if self.state.rodada_atual > self.state.n_rodadas:
			#self.state.rodada_atual -= 2
			uiHandler.show_final(win)
			return 
		uiHandler.enviar_rodada_to_proxima_rodada(new_rodada)
		
	else: # defeat

		uiHandler.show_final(win)
	updateUI(state)

func new_rodada( reverter_estado_do_envio : Callable):
	rodadaCont._criar_rodada(baralhoHandler.criar_hand_para_partida())
	reverter_estado_do_envio.bind(new_rodada).call()

func _on_pausa_but_pressed() -> void:
	uiHandler.switch_pause()


func _on_resumir_pressed() -> void:
	_on_pausa_but_pressed()


func _on_reiniciar_pressed() -> void:
	switch.emit(G.M.JOGAR, state.baralhoINFO)

func _on_sair_pressed() -> void:
	switch.emit(G.M.SELECT)

extends Control

class_name PartidaUIHandler

@onready var side_panel : VBoxContainer = get_node("Side_Panel/VBoxContainer")
@onready var menus : Control = get_node("Menus_Container")
@onready var pause_overlay : Panel = menus.get_node("pause_overlay")
@onready var menu_final : TextureRect = menus.get_node("Menu_Final")
@onready var menu_final_minus_button : TextureButton = menu_final.get_node("Minimizar")
@onready var pause_button : TextureButton = get_node("PausaBut")
@onready var envio_but : Button = side_panel.get_parent().get_node("Envio")


func update(_partida: PartidaRES) -> void:
	side_panel.get_node("Rodadas").text = "Rodada: " + str(_partida.rodada_atual) + " / " +  str(_partida.n_rodadas)  
	side_panel.get_node("Tentativas").text = "Tentativas: " + str(_partida.tentativas_usadas) + " / " +  str(_partida.n_tentativas)  
	%Pontuacao.text = str(_partida.points) +" pts"
	%DicasText.text = "Dicas: "+ str(_partida.dicas_usadas) + "/" + str(_partida.n_dicas)

func enviar_rodada_to_proxima_rodada(partida_state : PartidaRES, new_rodada : Callable):	
	envio_but.button_text = "Próxima Rodada"
	if envio_but.pressed.get_connections().filter(func (d : Dictionary) : return d.callable.get_method() == new_rodada.get_method()).size() > 0:
		envio_but.pressed.disconnect(new_rodada)
	envio_but.pressed.disconnect(_on_envio_pressed)
	envio_but.pressed.connect(new_rodada.bind(partida_state, reverter_estado_do_envio))

func reverter_estado_do_envio(new_rodada : Callable):
	envio_but.button_text = "Enviar Rodada"
	envio_but.pressed.disconnect(new_rodada)
	envio_but.pressed.connect(_on_envio_pressed)




func switch_pause() -> void:
	if pause_button.texture_normal == Res.pause_texture:
		pause_button.texture_normal = Res.resume_texture
		show_pause()
	else:
		pause_button.texture_normal = Res.pause_texture
		hide_pause()

func switch_pause_button():
	if %PausaBut.visible:
		%PausaBut.hide()
	else:
		%PausaBut.show()


func show_pause() -> void:
	pause_overlay.show()
	menus.show()
	menus.get_node("Menu_Pausa").show()

func hide_pause() -> void:
	pause_overlay.hide()
	menus.get_node("Menu_Pausa").hide()
	menus.hide()
	
func show_final(state : PartidaRES, win : bool) -> void:
	pause_overlay.show()
	menus.show()
	%Pontuacao_final.text = str(state.points) + " pontos"
	var mx = state.album.performances.max()
	print(mx)
	if  mx == null or state.points > mx:
		print("adas")
		%is_novo_melhor.show()
	
	%Erros_final.text = str(state.tentativas_usadas) + " erros"
	var final := menus.get_node("Menu_Final")
	final.show()
	pause_button.pressed.disconnect(get_parent().get_parent()._on_pausa_but_pressed)
	pause_button.pressed.connect(_on_minimizar_pressed)
	pause_button.top_level = true
	if win:
		final.get_node("Resultado").text = "Você ganhou!!!"
	else:
		final.get_node("Resultado").text = "Você perdeu..."

func _on_envio_pressed() -> void:
	get_parent().get_parent().rodadaCont._on_envio_pressed()


func _on_minimizar_pressed() -> void:
	if menu_final.visible:
		menu_final.hide()	
	else:
		menu_final.show()

func push_info(text : String = ""):
	%InfoText.text = text


func push_info_timer(text : String):
	var timer = %InfoTimer	
	timer.one_shot = true
	print("timerStart!")
	%InfoText.text = text
	timer.start(1)


func _show_dica(nome: String, text : String):
	#%pause_overlay.show()
	%Menu_Dica.get_node("ScrollContainer/Label").text = text
	%Menu_Dica.get_node("AutoSizeLabel").text = nome
	push_info("Uma dica gasta!")
	%Menus_Container.show()
	%Menu_Dica.show()
	

func _hide_dica():
	%Menus_Container.hide()
	%Menu_Dica.hide()
	%Menu_Dica.get_node("ScrollContainer/Label").text = ""
	push_info("")
	

signal wants_to_select_dica()
var dica_type_hint : String #"Dica" or "Descricao"

# func _disable_dica_buttons() ->void:

func block_side_panel() -> void:
	%block_side_panel.show()

func unblock_side_panel() -> void:
	%block_side_panel.hide()


func _on_dica_but_pressed() -> void:
	block_side_panel()
	%InfoText.text = "Selecione uma carta para expor a dica!"
	dica_type_hint = "Dica"
	wants_to_select_dica.emit()

func _on_descricao_but_pressed() -> void:
	block_side_panel()
	%InfoText.text = "Selecione uma carta para expor a dica!"
	dica_type_hint = "Descricao"
	wants_to_select_dica.emit()


func _on_card_handler_dica_card_selected(card: ControlCard) -> void:
	unblock_side_panel()
	match dica_type_hint:
		"Dica" : _show_dica(card.data.legenda, card.data.dica)
		"Descricao" : _show_dica(card.data.legenda, card.data.descricao)
		_: push_error("dica is not registered!")


func _on_sair_dica_pressed() -> void:
	_hide_dica()

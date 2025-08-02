extends Control

class_name PartidaUIHandler

@onready var side_panel : VBoxContainer = get_node("Side_Panel/VBoxContainer")
@onready var menus : Panel = get_node("Menus_Container")
@onready var pause_button : TextureButton = get_node("PausaBut")
func update(_partida: PartidaRES) -> void:
	side_panel.get_node("Rodadas").text = "Rodada: " + str(_partida.rodada_atual+1) + " / " +  str(_partida.n_rodadas)  
	side_panel.get_node("Tentativas").text = "Tentativas: " + str(_partida.tentativas_usadas) + " / " +  str(_partida.n_tentativas)  

func switch_pause() -> void:
	if pause_button.texture_normal == Res.pause_texture:
		pause_button.texture_normal = Res.resume_texture
		show_pause()
	else:
		pause_button.texture_normal = Res.pause_texture
		hide_pause()
	
func show_pause() -> void:
	
	menus.show()
	menus.get_node("Menu_Pausa").show()

func hide_pause() -> void:
	
	menus.get_node("Menu_Pausa").hide()
	menus.hide()
	
func show_final(win : bool) -> void:
	menus.show()
	var final := menus.get_node("Menu_Final")
	final.show()
	if win:
		final.get_node("Resultado").text = "Você ganhou!!!"
	else:
		final.get_node("Resultado").text = "Você perdeu..."



func _on_envio_pressed() -> void:
	get_parent().get_parent().rodadaCont._on_envio_pressed()

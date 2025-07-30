@tool
class_name CartaControlUIHandler extends Control

@onready var imagem : TextureRect = get_node("Imagem")
@onready var legenda : Label = get_node("Legenda")

func update(_data : CartaRES) -> void:
	imagem.texture = _data.imagem
	legenda.text = _data.legenda
	legenda.text = legenda.text + ""
	if !Engine.is_editor_hint() and G.debug:
		get_node("ano").text = _data.ano

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("activate_debug"):
		if G.debug:
			#print(G.debug)
			get_node("ano").text = get_parent().data.ano
		else:
			get_node("ano").text = ""

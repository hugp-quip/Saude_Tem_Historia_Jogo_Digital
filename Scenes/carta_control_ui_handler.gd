@tool
class_name CartaControlUIHandler extends Control

@onready var imagem : TextureRect = get_node("Imagem")
@onready var legenda : Label = get_node("Legenda")
@onready var ano : Label = get_node("ano")

func update(_data : CartaRES) -> void:
	imagem.texture = _data.imagem
	legenda.text = _data.legenda
	legenda.text = legenda.text + ""
	if !Engine.is_editor_hint() and G.debug and not (get_parent().is_slot()):
		ano.text = _data.ano
	
func clear() -> void:
	ano.text = ""
	ano.add_theme_color_override("font_color", Color.BLACK)
	

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("activate_debug"):
		if G.debug and not (get_parent().is_slot()) :
			#print(G.debug)
			get_node("ano").text = get_parent().data.ano
		else:
			get_node("ano").text = ""

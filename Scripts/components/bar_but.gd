@tool
class_name BaralhoButton extends Button


var data : BarRES
@onready var seeBarbut : TextureButton = %SeeBar

func _ready() -> void:
	call_deferred("insert")

func insert() -> void :
	%Imagem.texture = data.imagem
	%nome.text = data.nome

class_name RodadaCont extends Control

var rodada_config : RodadaRES
@onready var cardHan : ControlCardHandler = get_node("CardHandler")

func criar_rodada(partidaState : PartidaRES, cartas : Array)-> void:
	rodada_config = RodadaRES.new()
	rodada_config.n_cartas = partidaState.n_cartas
	rodada_config.cards = cartas
	print(cartas)
	cardHan.iniciar(cartas)



func _on_envio_pressed() -> void:
	push_error("Calmae ae paezão")
#	current_rodada._on_envio_pressed()

extends Object

class_name PartidaRES

@export var baralhoINFO : BarRES
var rodada_atual : int = 0
var tentativas_usadas: int = 0
@export var n_rodadas : int
@export var n_cartas : int = 5
@export var n_tentativas : int


@export var rodadaAT : int = 0
#@export var n_ajuda : int

func criar(_n_cartas: int, _baralhoRES: BarRES, _n_tentativas: int = 4) -> void:
	n_tentativas = _n_tentativas
	n_rodadas = clamp(_baralhoRES.cartas.size()/5, 1, 5)
	n_cartas = _n_cartas
	baralhoINFO = _baralhoRES

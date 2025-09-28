extends Object

class_name PartidaRES

@export var baralhoINFO : BarRES
@export var album : AlbumRes
var rodada_atual : int = 1
var tentativas_usadas: int = 0 :
	set(v) :
		tentativas_usadas = v

		points = points - 100 if points - 100 > 0 else 0
		
@export var n_rodadas : int
@export var n_cartas : int = 5
@export var n_tentativas : int
@export var points : int = 0 
	

@export var rodadaAT : int = 0
@export var rodadas : Array[RodadaRES] # [rod1, rod2]
#@export var n_ajuda : int

func criar(_n_cartas: int, _baralhoRES: BarRES, _albumRES : AlbumRes ,_n_tentativas: int = 4) -> void:
	n_tentativas = _n_tentativas
	
	n_rodadas = clamp(int(_baralhoRES.cartas.size()/5.0), 1, 5)
	n_cartas = _n_cartas
	baralhoINFO = _baralhoRES
	album = _albumRES

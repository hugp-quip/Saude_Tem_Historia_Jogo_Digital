extends Node

class_name BaralhoHandler

var cartas : Array # -> list containing the ids of all the cards.
var used_cartas : Array # -> list containing the id of used cards.
var n_cartas_partida : int
#@onready var random : RandomNumberGenerator = RandomNumberGenerator.new()
var cartaRESCache : Array[CartaRES] = []

func comecar(_baralhoAT: BarRES, _n_rodadas: int, n_cartas: int) -> void:
	#assert(_baralhoAT.cartas.size()/n_cartas >= n_rodadas, "BARALHO MUITO PEQUENO PARA O NÚMERO DE RODADAS REQUISITADO!!!")
	n_cartas_partida = n_cartas
	cartas = _baralhoAT.cartas.duplicate()
	used_cartas = []

func criar_hand_para_partida() -> Array:
	var cartas_restantes : int = cartas.size() -  used_cartas.size() 
	#assert(cartas_restantes > 1, "TENTOU CRIAR MÃO COM CARTAS INSUFICIENTES!!!")
	var _cartaIDS := _get_hand(clamp(cartas_restantes, 2, n_cartas_partida) as int)
	var cartasRES : Array = []
	
	var cartaRESCache_id = cartaRESCache.map(func (c : CartaRES) : return c.id)
	for id : int in _cartaIDS:
		var id_is_cached : int = cartaRESCache_id.find(id)
		var res : CartaRES
		if id_is_cached > -1:
			res = cartaRESCache[id_is_cached]
		else:
			res = ResourceLoader.load("res://Resources/Cartas/" + str(id)+".res")
			cartaRESCache.append(res)
		cartasRES.append(res)
	
	return cartasRES

func load_cards_in_album_to_cache(partida_state : PartidaRES) -> Array[CartaRES]:
	var cartaRESCache_id = cartaRESCache.map(func (c : CartaRES) : return c.id)
	var ret : Array[CartaRES] = []
	for carta_id : int in partida_state.album.completedCartas:
		if not( carta_id in cartaRESCache_id):
			var loaded : CartaRES = ResourceLoader.load("res://Resources/Cartas/" + str(carta_id)+".res")
			cartaRESCache.append(loaded)
			ret.append(loaded)
		else:
			ret.append(cartaRESCache[cartaRESCache_id.find(carta_id)])
	return ret


func load_all_baralho_to_cache(partida_state : PartidaRES) -> void:
	var cartaRESCache_id = cartaRESCache.map(func (c : CartaRES) : return c.id)
	for id : int in partida_state.baralhoINFO.cartas:
		if not (id in cartaRESCache_id):
			cartaRESCache.append(ResourceLoader.load("res://Resources/Cartas/" + str(id)+".res"))
		

func _get_hand(n_cartas : int) -> Array:
	if not (n_cartas > 0 and n_cartas < cartas.size() - used_cartas.size()):
		push_error("NÚMERO DE CARTAS REQUISITADO MAIOR DO QUE O TAMANHO RESTANTE DO BARALHO") 
		return []
	var cartasID : Array = []
	while cartasID.size() < n_cartas:
		var r : int = G.rand.randi_range(0, cartas.size()-1) 
		if not (cartas[r] in used_cartas):
			cartasID.append(cartas[r])
			used_cartas.append(cartas[r])
	return cartasID	

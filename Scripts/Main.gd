extends Control


@onready var menu := get_node("Menu")
@onready var atual : Node = menu.get_child(0)
var testbuffer 
func _ready() -> void:
	menu.get_child(0).switch.connect(_on_switch)
	# testbuffer = load("res://Resources.pck")
	# print(testbuffer)
	# if ProjectSettings.load_resource_pack("res://Resources.pck", true):
	# 	print("loaded decks!")
	# else:
	# 	print("didn't load decks!")

# func partidaTESTE()
	# atual.queue_free()
	# atual = load("res://Scenes/pages/NEWPartida.tscn").instantiate()
	# var part : PartidaRES = PartidaRES.new()
	# part.criar(5, load("res://Resources/Baralhos/AIDS.res")) 
	# atual.criar_partida(part)
	# add_child(atual)
func corrigirCartas():
	var path_cartas := "Cartas/"
	var path_imagens: = "Cartas_Imagens/"
	var resources: = "res://Resources/"
	var deprecated := "res://Resources/deprecated/"
	var file := DirAccess.open(deprecated.path_join(path_imagens))
	var str_files = file.get_files()
	for str_old_id : String in str_files:
		(path_imagens.path_join(str_old_id))
		#res://Resources/Cartas_Imagens/0.res
		(deprecated.path_join(path_imagens.path_join(str_old_id)))
		var img : ImageTexture = ResourceLoader.load(deprecated.path_join(path_imagens.path_join(str_old_id)))
		var carta : CartaRES = ResourceLoader.load(deprecated.path_join(path_cartas.path_join(str_old_id)))
		
		ResourceSaver.save(img, resources.path_join(path_imagens).path_join(str(carta.id) + ".res"))
		var img2 : ImageTexture = ResourceLoader.load(resources.path_join(path_imagens).path_join(str(carta.id) + ".res"))
		carta.imagem = img2
		ResourceSaver.save(carta, resources.path_join(path_cartas).path_join(str(carta.id) + ".res"))

func _on_switch(new:int, baralho: BarRES = null, album: AlbumRes = null) -> int:
	#_convert_to_binary()
	#partidaTESTE()
	# corrigirCartas()
	# get_tree().quit()
	# return 1

	if new == G.M.EXIT:
		#savebeforequiting()
		get_tree().quit()
		return 4
	elif new == G.M.JOGAR:
		atual.queue_free()
		atual = G.menus[new].instantiate()
		var part2 : PartidaRES = PartidaRES.new()
		part2.criar(G.n_cartas, baralho, album)
		atual.criar_partida(part2)

		menu.add_child(atual)
		menu.get_child(1).switch.connect(_on_switch)
		return 0
	elif new == G.M.INICIAL:
		
		pass
	elif new == G.M.ALBUM:
		atual.queue_free()
		atual = G.menus[new].instantiate()
		menu.add_child(atual)
		var partRES: PartidaRES = PartidaRES.new()
		partRES.baralhoINFO = baralho
		partRES.album = album
		var baralhoHandler : = BaralhoHandler.new()
		baralhoHandler.load_all_baralho_to_cache(partRES)
		var _correct_cards : Array[CartaRES] = baralhoHandler.load_cards_in_album_to_cache(partRES)
		atual.iniciar_album_partida(_correct_cards, baralhoHandler.cartaRESCache, partRES)
		
		menu.get_child(1).switch.connect(_on_switch)
		return 0
	elif new == G.M.RANKING:
		atual.queue_free()
		
		atual = G.menus[new].instantiate()
		menu.add_child(atual)
		menu.get_child(1).switch.connect(_on_switch)
		atual.iniciar_ranking_page(album)
		return 0
	
	atual.queue_free()
	atual = G.menus[new].instantiate()
	menu.add_child(atual)
	menu.get_child(1).switch.connect(_on_switch)
	return 0

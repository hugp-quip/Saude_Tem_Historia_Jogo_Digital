extends Control


@onready var menu := get_node("Menu")
@onready var atual : Node = menu.get_child(0)

func _ready() -> void:
	menu.get_child(0).switch.connect(_on_switch)

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
		print(path_imagens.path_join(str_old_id))
		#res://Resources/Cartas_Imagens/0.res
		print(deprecated.path_join(path_imagens.path_join(str_old_id)))
		var img : ImageTexture = ResourceLoader.load(deprecated.path_join(path_imagens.path_join(str_old_id)))
		var carta : CartaRES = ResourceLoader.load(deprecated.path_join(path_cartas.path_join(str_old_id)))
		
		ResourceSaver.save(img, resources.path_join(path_imagens).path_join(str(carta.id) + ".res"))
		var img2 : ImageTexture = ResourceLoader.load(resources.path_join(path_imagens).path_join(str(carta.id) + ".res"))
		carta.imagem = img2
		ResourceSaver.save(carta, resources.path_join(path_cartas).path_join(str(carta.id) + ".res"))

func _on_switch(new:int, data: BarRES = null) -> int:
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
		#assert(data != null, "TRIED CREATING PARTIDA WITHOUT BARALHO.")
		# #assert(not (data.baralhoAT is BaralhoINFO), "TRIED STARTING A PARTIDA WITH THE OLD BARALHO MODEL.")
		
		# btw to find a type by name use "type_string(type_off())"
		atual.queue_free()
		atual = G.menus[new].instantiate()
		var part2 : PartidaRES = PartidaRES.new()
		part2.criar(G.n_cartas, data)
		atual.criar_partida(part2)

		menu.add_child(atual)
		menu.get_child(1).switch.connect(_on_switch)
		return 0
	elif new == G.M.INICIAL:
		#create_new_baralhos()
		pass
	
	atual.queue_free()
	atual = G.menus[new].instantiate()
	menu.add_child(atual)
	menu.get_child(1).switch.connect(_on_switch)
	return 0

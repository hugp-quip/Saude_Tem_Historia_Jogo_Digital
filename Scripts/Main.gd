extends Control


@onready var menu := get_node("Menu")
@onready var atual : Node = menu.get_child(0)
var testbuffer 
var testImage : ImageTexture
func _ready() -> void:
	menu.get_child(0).switch.connect(_on_switch)
	
	if FileAccess.open("res://user_cookies.gd", FileAccess.READ):
		var user_cookies : String = load("res://user_cookies.gd").get_global_name() if load("res://user_cookies.gd") != null else "" 
		print(user_cookies)
		
	#print(user_cookies.get_as_text())

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

func adicionar_novas_cartas():
	#Nome, Ano, Dica, Img
	var main_path = "res://EXPOTEC 2025/Imagens Cartas Saude tem Historia"
	var aids_path = "AIDS.csv"
	var saude_path = "Saúde Pública e Mundial.csv"
	var img_aids_path = "Imagens_AIDS_quad"
	var img_saude_path = "Imagens Saúde Pública e Mundial quad"	

	var aids_csv = FileAccess.open(main_path.path_join(saude_path), FileAccess.READ)

	print(aids_csv.get_as_text())

	aids_csv.get_csv_line() #remover primeira linha
	var i = 30
	var allCards = []

	var current_csv = aids_csv
	while true:
		var linha : PackedStringArray = current_csv.get_csv_line()
		if current_csv.eof_reached():
			# if current_csv == aids_csv:

				
			# 	current_csv = FileAccess.open(main_path.path_join(saude_path), FileAccess.READ)
			# else:
				break
		#print(linha)
		#if i == 0: continue
		# var test : CompressedTexture2D = load(main_path.path_join(img_aids_path.path_join(linha[3].split(".")[0]+".png")))
		# var test2 = test.get_image()
		# print(test.get_image())
		# var test3 = ImageTexture.create_from_image(test.get_image())
		# testImage = test3
		# ResourceSaver.save(testImage, "res://testImage.res")
		# assert(false)
		#G.makeResourceFromImage(main_path.path_join(img_aids_path.path_join(linha[3])))
		
		var carta : CartaRES = CartaRES.new()
		print(linha[0] + "image name: " + linha[3] )
		var img : ImageTexture = ImageTexture.create_from_image(load(main_path.path_join(img_saude_path.path_join(linha[3].split(".")[0]+".png"))).get_image())
		print(error_string(ResourceSaver.save(img, "res://Resources/Cartas_Imagens/"+str(i)+".res")))
		
		#var img2 : ImageTexture = load("res://Resources/Cartas_Imagens/"+str(i)+".res")
		
		carta.criar_cartaRES( i,  linha[0], linha[2], linha[1], img)
		
		print(error_string(ResourceSaver.save(carta, "res://Resources/Cartas/"+str(i)+".res")))

		allCards.append(carta)
		i+=1
	assert(false)


func adicionar_novas_cartas_aos_baralhos():
	var aids : BarRES = load("res://Resources/Baralhos/Saúde Pública.res")
	aids.cartas = range(30, 29+36) # uma linha é falsa
	ResourceSaver.save(aids, "res://Resources/Baralhos/Saúde Pública.res")




func _on_switch(new:int, baralho: BarRES = null, album: AlbumRes = null) -> int:
	#adicionar_novas_cartas_aos_baralhos()

	#adicionar_novas_cartas()
	# # corrigirCartas()
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

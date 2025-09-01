@tool
extends Control
signal switch(new:int, data : Dictionary)

var barBut : PackedScene = load("res://Scenes/components/bar_but.tscn")
var baralhoAT: BarRES
var albumAT : AlbumRes
@export var node : Node
func _ready() -> void:
	if Engine.is_editor_hint():
		for i in 5:
			var _but : BaralhoButton = barBut.instantiate()
			var bar : BarRES = BarRES.new()
			bar.criar_BarRES(0, "noome", null, "desc", [])
			_but.data = bar
			%BarButs.add_child(_but)
	else:
		refreshDecks()
		
func _inspect_bar(bar : BarRES) -> void:
	print("babaoye")

func refreshDecks() -> void:
	for bar : Resource in G.baralhoCache:
		var _but := barBut.instantiate()
		_but.data = bar
		_but.pressed.connect(_barSelected.bind(bar, null))
		
		%BarButs.add_child(_but)
		_but.seeBarbut.pressed.connect(_inspect_bar.bind(_but.data))
	
	if G.baralhoAT != null: # -> if no baralho selected, then select one.
		_barSelected(G.baralhoAT, G.albumAT)
	else:
		_barSelected(G.baralhoCache[0] as BarRES, null)#AlbumRes.new())



func _barSelected(bar : BarRES, alb : Resource) -> void:
	if alb == null:
		var albuns_id : Array = G.albumCache.map(func (a : AlbumRes) : return a.id)
		if bar.id in albuns_id:
			var index : int = G.albumCache.find_custom(func (a : AlbumRes) : return a.id == bar.id)
			if index == -1: push_error("de alguma forma o álbum existe e n existe no cache????")
			alb = G.albumCache[index]
		else:
			alb = AlbumRes.new()
			alb.id = bar.id
			alb.nome = bar.nome
			G.albumCache.append(alb)

	baralhoAT = bar
	albumAT = alb
	G.albumAT = alb
	G.baralhoAT = bar
	G.baralhoAtual = G.decks + G.baralhoAT.nome	

	%DescText.text = bar.descricao

	%nomeDeck.text = G.baralhoAT.nome
	%JOGAR.disabled = false
	%SeeAlb.disabled = false
	%SeeRanking.disabled = false

func stripClones(a: Array) -> Array:
	var sb : Array = []
	for i in a:
		if i not in sb:
			sb.append(i)
	return sb

func _on_voltar_pressed() -> void:
	switch.emit(G.M.INICIAL)

func _on_jogar_pressed() -> void:
	switch.emit(G.M.JOGAR, G.baralhoAT, G.albumAT)

func _on_see_alb_pressed() -> void:
	switch.emit(G.M.ALBUM, G.baralhoAT, G.albumAT)


func _on_see_ranking_pressed() -> void:
	switch.emit(G.M.RANKING, null, G.albumAT)

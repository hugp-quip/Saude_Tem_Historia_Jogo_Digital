extends PanelContainer

signal switch(new:int)

func iniciar_ranking_page(alb: AlbumRes) :
	%nomeAlb.text = alb.nome

	var i : int =1
	
	if alb.performances.size() > 0:
		var arr : Array = alb.performances.duplicate()
		arr.reverse()
		for p : int  in arr:
			var lbl : Label = load("res://Scenes/components/performance_label.tscn").instantiate()
			lbl.text = str(i) + ". "+ str(p) + " pts"
			%perfomances.add_child(lbl)
	else:
		var lbl : Label = load("res://Scenes/components/performance_label.tscn").instantiate()
		lbl.text = "Não há performances para esse baralho!"
		%perfomances.add_child(lbl)

func _on_button_pressed() -> void:
	switch.emit(G.M.SELECT)

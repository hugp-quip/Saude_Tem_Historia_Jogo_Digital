class_name RodadaCont extends Control


signal finished_with_win( win: bool)
signal needs_update_ui( state: PartidaRES)

var rodada_state : RodadaRES
@onready var cardHan : ControlCardHandler = get_node("CardHandler")
@onready var slotMan : ControlSlotManager = cardHan.slotMan
@onready var judge : NewRodadaJudge = get_node("RodadaJudge")
@onready var animHan : RodadaAnimationHandler = get_node("AnimationHandler")
var partida_state : PartidaRES


func criar_primeira_rodada(partidaState : PartidaRES, cartas : Array)-> void:
	rodada_state = RodadaRES.new()
	rodada_state.n_cartas = partidaState.n_cartas
	rodada_state.cards = cartas
	cardHan.iniciar(cartas)
	judge.slotMan = slotMan
	partida_state = partidaState
	rodar_inicio_animacao.call_deferred()

func _criar_rodada(_partida_state : PartidaRES, cartas : Array) -> void:
	rodada_state = RodadaRES.new()
	rodada_state.n_cartas = _partida_state.n_cartas
	rodada_state.cards = cartas

	if cartas.size() != 0:
		cardHan.reiniciar(cartas)
		rodar_inicio_animacao.call_deferred()

func rodar_inicio_animacao() -> void:
	animHan.run_start_animation()

func _on_envio_pressed() -> void:
	var results
	results = judge.get_rodada_results(rodada_state.correct_cards)
	
	
	
	if not (results.has_result): return
	
	var fb : JudgeFeedBack = Res.feedback.instantiate()
	print(results)
	results.correct_cards.map(func (card : ControlCard) : card.silence() )

	rodada_state.correct_cards.append_array(results.correct_cards.map(func (c : ControlCard) : return c.data))

	partida_state.points += results.points
	
	if rodada_state.correct_cards.size() == G.n_cartas:
		("ganhou!")
		enviar_feedback_padrao(results, fb)
		finished_with_win.emit(true)
		#already_correct_cards = []
		return
	elif partida_state.n_tentativas - 1 > partida_state.tentativas_usadas:
		enviar_feedback_padrao(results, fb)
		("tente novamente!")
		partida_state.tentativas_usadas += 1
		needs_update_ui.emit(partida_state)
	else:
		("perdeu!!!")
		partida_state.tentativas_usadas += 1
		enviar_feedback_derrota(results, fb)
		finished_with_win.emit(false)
		#already_correct_cards = []
		return

const color_green ="#609e22ff"

func enviar_feedback_derrota(results : Dictionary, fb : JudgeFeedBack) -> void:
	results.incorrect_cards.map(func (card : ControlCard) : card.silence() )
	results.relative_correct_cards.map(func (card : ControlCard) : card.silence() )
	enviar_feedback(results.correct_cards, fb.FEEDBACK.CORRECT, color_green)
	enviar_feedback(results.incorrect_cards, fb.FEEDBACK.INCORRECT, "#FF0000")
	enviar_feedback(results.relative_correct_cards, fb.FEEDBACK.INCORRECT, "#cc0000ff")


func enviar_feedback_padrao(results : Dictionary, fb : JudgeFeedBack) -> void:
	enviar_feedback(results.correct_cards, fb.FEEDBACK.CORRECT, color_green)
	enviar_feedback(results.incorrect_cards, fb.FEEDBACK.INCORRECT, "#FF0000")
	enviar_feedback(results.relative_correct_cards, fb.FEEDBACK.INCORRECT, "#cc0000ff")


func enviar_feedback( cards: Array, feedback_type: int ,ano_color: String ):
	for card in cards:
		var lab : Label = card.get_node("Carta_Control_UI_Handler").get_node("ano")
		lab.add_theme_color_override("font_color", Color(ano_color))
		var fb : JudgeFeedBack = Res.feedback.instantiate()
		
		lab.visible = true
		if feedback_type == fb.FEEDBACK.CORRECT: 
			lab.text = card.data.ano
		else:
			lab.text = "XXXX"
		card.add_child(fb)
		fb.criar_feedback(feedback_type)
		
	

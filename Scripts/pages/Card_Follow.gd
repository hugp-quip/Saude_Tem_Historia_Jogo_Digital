@tool
extends PathFollow2D

@onready var start_timer : Timer= get_node("StartTimer")
@onready var card : ControlCard = get_node("Control_Card")
var can_start : bool = false
var wait_time: float
var fullpath : float
var is_main_scene : bool = true
func _ready() -> void:
	is_main_scene = not(get_parent() is Path2D)
	start_timer.start(wait_time)
	card.scale = Vector2(0.75, 0.75)
	card.make_card(util.random_card_res())
	card.get_node("Carta_Control_UI_Handler/Legenda").add_theme_constant_override("line_spacing", 0)
	card.get_node("Carta_Control_UI_Handler/Legenda").add_theme_font_size_override("font_size", 10)

func _on_start_timer_timeout() -> void:
	can_start = true
	print("started")

	
func _physics_process(_delta: float) -> void:
	if not (self.is_main_scene):
		if self.progress >= self.fullpath - 10: card.make_card(util.random_card_res())
		if can_start: self.progress += 240*_delta


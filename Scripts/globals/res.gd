extends Node

@onready var cardBackground := preload("res://Assets/carta.png")
@onready var slotBackground := preload("res://Assets/slot.PNG")
#@onready var rodada := preload("res://Scenes/pages/Rodada.tscn")
#@onready var cardDisplay := preload("res://Scenes/components/OLDCardDisplay.tscn")
#@onready var nodeCardDisplay := load("res://Scenes/components/node_carta_display.tscn")
#@onready var nodeSlot := load("res://Scenes/components/slot.tscn")
@onready var controlCardDisplay := load("res://Scenes/components/Control_Card.tscn")
@onready var feed_back_correct := load("res://Assets/Crt.PNG")
@onready var feed_back_error := load("res://Assets/Err.PNG")
@onready var feed_back_almost := load("res://Assets/Alm.PNG")
@onready var feedback := load("res://Scenes/components/feed_back.tscn")
@onready var pause_texture := load("res://Assets/pause.png")
@onready var resume_texture := load("res://Assets/resume.png")
var pathCartas := "res://Resources/Cartas"
var n_cards = 64
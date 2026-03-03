extends Node2D

const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARD_DRAW_SPEED = 0.2
const CARD_COUNT = 7

# Define o deck
@onready var card_database_reference = preload("res://scripts/Scripts_Solo/GPT_vitoria_card_database.gd")
var player_deck = ["V", "I", "T", "O", "R", "I", "A"] # ELEMENTOS DO DECK, MUDE DE ACORDO COM SUA DATABASE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(CARD_COUNT):
		draw_card()


# Desenha as cartas
func draw_card():
	var card_draw_name = player_deck[0]
	player_deck.erase(card_draw_name)
	
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	## Imagens das cartas
	var card_image_path = str("res://assents/cads/GPT/" + card_draw_name + ".png") #Olha o caminho + nome
	new_card.get_node("CardBase").texture = load(card_image_path)
	$"../vitoria_chat_card".add_child(new_card)
	new_card.name = "Card"
	$"../vitoria_chat_hand".add_card_to_hand(new_card, CARD_DRAW_SPEED)



func reset_deck():
	for child in $"../vitoria_chat_card".get_children():
		child.queue_free()
	
	$"../vitoria_chat_hand".player_hand.clear()
	player_deck = ["V", "I", "T", "O", "R", "I", "A"]

func refill_hand():
	reset_deck()
	
	for i in range(CARD_COUNT):
		draw_card()

extends Node2D

const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARD_DRAW_SPEED = 0.2
const CARD_COUNT = 4

# Define o deck
@onready var card_database_reference = preload("res://scripts/Scripts_Solo/GPT_card_database.gd")
var player_deck = ["A", "B", "C", "D"] # ELEMENTOS DO DECK, MUDE DE ACORDO COM SUA DATABASE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player_deck.shuffle() # Randomiza as cartas que vão aparecer
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
	$"../Chat_cardManager".add_child(new_card)
	new_card.name = "Card"
	$"../Chat_PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)
	#define o index de cada carta para conferir com a resposta
	match card_draw_name:
		"A":
			new_card.option_index = 0
		"B":
			new_card.option_index = 1
		"C":
			new_card.option_index = 2
		"D":
			new_card.option_index = 3


func reset_deck():
	for child in $"../Chat_cardManager".get_children():
		child.queue_free()
	
	$"../Chat_PlayerHand".player_hand.clear()
	player_deck = ["A", "B", "C", "D"]
	player_deck.shuffle()

func refill_hand():
	reset_deck()
	
	for i in range(CARD_COUNT):
		draw_card()

extends Node2D

const CARD_DRAW_SPEED = 0.2
const HAND_COUNT = 6

## CARTAS DISPONIVEIS NO DECK
var player_deck = [
	"ID_1", 
	"ID_2", 
	"ID_3", 
	"ID_4",
	"ID_5",
	"ID_6",
	"ID_7",
	"ID_8",
	"ID_9",
	"ID_0"
	]
@onready var player_hand = $"../Player_Hand"
@onready var card_scene = preload("res://scenes/main scenes/gemini/card_gemini.tscn")

var card_resource = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_sprites()
	
	for i in range(HAND_COUNT):
		draw_card()


# Desenha as cartas
func draw_card():
	var card_name = player_deck.pick_random()
	var new_card = card_scene.instantiate()
	new_card.global_position = $"../Marker2D".position
	
	$"..".add_child.call_deferred(new_card)
	
	add_sprite(new_card, card_name) # <-- passa a carta
	
	player_hand.add_card_to_hand(new_card)
	
	
func load_sprites():
	card_resource = {
		"ID_1": preload("res://scenes/main scenes/gemini/sprites_cartas/1.png"),
		"ID_2": preload("res://scenes/main scenes/gemini/sprites_cartas/2.png"),
		"ID_3": preload("res://scenes/main scenes/gemini/sprites_cartas/3.png"),
		"ID_4": preload("res://scenes/main scenes/gemini/sprites_cartas/4.png"),
		"ID_5": preload("res://scenes/main scenes/gemini/sprites_cartas/5.png"),
		"ID_6": preload("res://scenes/main scenes/gemini/sprites_cartas/6.png"),
		"ID_7": preload("res://scenes/main scenes/gemini/sprites_cartas/7.png"),
		"ID_8": preload("res://scenes/main scenes/gemini/sprites_cartas/8.png"),
		"ID_9": preload("res://scenes/main scenes/gemini/sprites_cartas/9.png"),
		"ID_0": preload("res://scenes/main scenes/gemini/sprites_cartas/0.png")
	}

func add_sprite(card_node, key_card):
	var sprite = card_node.get_node("CardBase")
	sprite.texture = card_resource[key_card]

func check_card(card):
	pass

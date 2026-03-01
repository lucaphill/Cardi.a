extends Node2D

const CARD_DRAW_SPEED = 0.2
const HAND_COUNT = 6

## CARTAS DISPONIVEIS NO DECK
var player_deck = ["ID_1", "ID_2", "ID_3", "ID_4"]
@onready var player_hand = $"../Player_Hand"
@onready var card_scene = preload("res://scenes/card.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(HAND_COUNT):
		draw_card()


# Desenha as cartas
func draw_card():
	var new_card = card_scene.instantiate()
	new_card.global_position = $"../Marker2D".position
	$"..".add_child.call_deferred(new_card)
	$"../Player_Hand".add_card_to_hand(new_card)

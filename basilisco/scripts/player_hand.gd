extends Node2D

const CARD_SCENE_PATH = "res://scenes/card.tscn"
const HAND_Y_POSITION = 690
const DEFALT_CARD_MOVE_SPEED = 0.1


var card_width = 120
var card_angle = 0
var player_hand = []
var center_screen_x
@onready var spawn = $"../Marker2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2 + 190


# Adiciona a carta a sua mão
func add_card_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions()
	else:
		animate_card_to_position(spawn, card.hand_position, DEFALT_CARD_MOVE_SPEED)

# Atualiza a posição das cartas dependendo da quantidade
func update_hand_positions():
	for i in range(player_hand.size()):
		# Estamos definindo a posição de cada carta baseado no index de cartas na nossa mão
		var new_position = Vector2(calculate_card_position(i), HAND_Y_POSITION)
		var card = player_hand[i]
		card.hand_position = new_position
		animate_card_to_position(card, new_position, DEFALT_CARD_MOVE_SPEED)

func calculate_card_position(index):
	var total_width = (player_hand.size() -1) * card_width
	var x_offset = center_screen_x + index * card_width - total_width / 2
	return x_offset


func animate_card_to_position(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)
	
func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions()

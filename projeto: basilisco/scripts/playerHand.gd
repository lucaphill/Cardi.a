extends Node2D

const DEFALT_CARD_MOVE_SPEED = 0.1

var hand_y_position
var card_width = 120
var card_angle = 0
var player_hand = []
var center_screen_x

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand_y_position = get_viewport().size.y / 1.1
	center_screen_x = get_viewport().size.x / 2
	

# Adiciona a carta a sua mão
func add_card_to_hand(card, speed):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions(speed)
	else:
		animate_card_to_position(card, card.hand_position, DEFALT_CARD_MOVE_SPEED)

# Atualiza a posição das cartas dependendo da quantidade
func update_hand_positions(speed):
	for i in range(player_hand.size()):
		# Estamos definindo a posição de cada carta baseado no index de cartas na nossa mão
		var new_position = Vector2(calculate_card_position(i), hand_y_position)
		var card = player_hand[i]
		card.hand_position = new_position
		animate_card_to_position(card, new_position, speed)

func calculate_card_position(index):
	var total_width = (player_hand.size() -1) * card_width
	var x_offset = center_screen_x + index * card_width - total_width / 2
	return x_offset


func animate_card_to_position(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
	
func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions(DEFALT_CARD_MOVE_SPEED)

extends Node2D

const DEFALT_CARD_MOVE_SPEED = 0.1

var hand_y_position = 680
var y_offset
var card_width = 120
var card_angle = 0
var player_hand = []
var center_screen_x
var max_angle = 20.0
var curve_strength = 20


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	center_screen_x = get_viewport().size.x / 2 + 130
	

# Adiciona a carta a sua mão
func add_card_to_hand(card, speed):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions(speed)
	else:
		animate_card_to_position(card, card.hand_position, DEFALT_CARD_MOVE_SPEED)

# Atualiza a posição das cartas dependendo da quantidade
func update_hand_positions(speed):
	var hand_size = player_hand.size()
	
	for i in range(hand_size):
		var card = player_hand[i]
		
		var center_index = (hand_size - 1) / 2.0
		var distance_from_center = i - center_index
		# X
		var x_pos = calculate_card_position(i)
		# CURVATURA
		var y_curve = pow(distance_from_center, 2) * curve_strength
		var new_position = Vector2(x_pos, hand_y_position + y_curve)
		card.hand_position = new_position
		
		# ÂNGULO
		var angle = 0.0
		if hand_size > 1:
			var t = float(i) / float(hand_size - 1)
			angle = lerp(-max_angle, max_angle, t)
		
		animate_card(card, new_position, angle, speed)

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


func animate_card(card, new_position, angle, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
	tween.tween_property(card, "rotation_degrees", angle, speed)

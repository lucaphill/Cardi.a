extends Node2D


const DEFAULT_CARD_MOVE_SPEED = 0.1

var hand_y_position = 640
var card_width = 120
var player_hand = []
var max_angle = 20.0
var curve_strength = 20


func add_card_to_hand(card, speed):
	if card not in player_hand:
		player_hand.insert(0, card)
		update_hand_positions(speed)
	else:
		animate_card_to_position(card, card.hand_position, DEFAULT_CARD_MOVE_SPEED)


func update_hand_positions(speed):
	var hand_size = player_hand.size()
	for i in range(hand_size):
		var card = player_hand[i]
		var center_index = (hand_size - 1) / 2.0
		var distance_from_center = i - center_index
		var x_pos = calculate_card_position(i)
		var y_curve = pow(distance_from_center, 2) * curve_strength
		var new_position = Vector2(x_pos, hand_y_position + y_curve)
		card.hand_position = new_position
		var angle = 0.0
		if hand_size > 1:
			var t = float(i) / float(hand_size - 1)
			angle = lerp(-max_angle, max_angle, t)
		animate_card(card, new_position, angle, speed)


func calculate_card_position(index) -> float:
	# Calcula sempre direto do viewport — evita problema de ordem de _ready()
	var center = get_viewport().size.x / 2.0 + 200
	var total_width = (player_hand.size() - 1) * card_width
	return center + index * card_width - total_width / 2.0


func animate_card_to_position(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)


func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions(DEFAULT_CARD_MOVE_SPEED)


func animate_card(card, new_position, angle, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
	tween.tween_property(card, "rotation_degrees", angle, speed)

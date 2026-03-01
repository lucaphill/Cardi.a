extends Node2D

const COLLISION_MASK_CARD = 1

var card_in_slot = false
var current_card = null

# Reseta o slot de cartas
func reset_card_slot():
	
	card_in_slot = false
	$Area2D/CollisionShape2D.disabled = false
	if current_card:
		current_card.queue_free() # remove a carta da cena
		current_card = null

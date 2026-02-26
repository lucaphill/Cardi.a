extends Node2D

const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARD_DRAW_SPEED = 0.2


## CARTAS DISPONIVEIS NO DECK
var player_deck = ["oi", "oi", "oi", "oi"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$RichTextLabel.text = str(player_deck.size())


# Desenha as cartas
func draw_card():
	var card_draw = player_deck[0]
	player_deck.erase(card_draw)
	
	# Deois de pegar a ultima carta, o deck some
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true # Desativa a colisão com o Deck
		$Sprite2D.visible = false # Faz o deck sumir
		$RichTextLabel.visible = false # desativa o contador
	
	$RichTextLabel.text = str(player_deck.size())
	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	$"../PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)

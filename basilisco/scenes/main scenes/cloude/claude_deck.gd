extends Node2D
# gerente do deck 
# sem arte ainda 

const CARD_SCENE_PATH = "res://scenes/card.tscn"
const CARD_DRAW_SPEED = 0.2
const CARD_COUNT = 4

var card_labels: Array = []  # Preenchido pela interface com os textos das cartas
var player_deck: Array = []   # [A, B C,D]


func setup_deck(labels: Array):
	card_labels = labels
	player_deck = ["A", "B", "C", "D"]
	# cada uma é específica 


func draw_all_cards():
	for i in range(CARD_COUNT):
		draw_card()


func draw_card():
	if player_deck.is_empty():
		return

	var card_draw_name = player_deck[0]
	player_deck.erase(card_draw_name)

	var card_scene = preload(CARD_SCENE_PATH)
	var new_card = card_scene.instantiate()

	# Usa o CardTemplate de luca
	new_card.get_node("CardBase").texture = load("res://assents/jp/New Piskel.png")

	# Adiciona Label com o texto da carta por cima
	var label = Label.new()
	label.name = "CardLabel"
	label.text = get_label_for_card(card_draw_name)
	var font = load("res://assents/jp/Amarante-Regular.ttf")
	label.add_theme_font_override("font", font)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size = Vector2(160, 240)
	label.position = Vector2(-80, -120)
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", Color(0.1, 0.1, 0.1))
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	new_card.add_child(label)

	$"../Claude_CardManager".add_child(new_card)
	new_card.z_index = 3
	new_card.name = "Card"

	# Define inedx por letra
	match card_draw_name:
		"A":
			new_card.option_index = 0
		"B":
			new_card.option_index = 1
		"C":
			new_card.option_index = 2
		"D":
			new_card.option_index = 3

	$"../Claude_PlayerHand".add_card_to_hand(new_card, CARD_DRAW_SPEED)


func get_label_for_card(card_name: String) -> String:
	match card_name:
		"A": return card_labels[0] if card_labels.size() > 0 else "A"
		"B": return card_labels[1] if card_labels.size() > 1 else "B"
		"C": return card_labels[2] if card_labels.size() > 2 else "C"
		"D": return card_labels[3] if card_labels.size() > 3 else "D"
	return ""


func reset_deck():
	for child in $"../Claude_CardManager".get_children():
		child.queue_free()
	$"../Claude_PlayerHand".player_hand.clear()
	player_deck = ["A", "B", "C", "D"]


func refill_hand(new_labels: Array):
	reset_deck()
	setup_deck(new_labels)
	draw_all_cards()

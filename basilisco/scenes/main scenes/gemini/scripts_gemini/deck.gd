extends Node2D

var card_scene = preload("res://scenes/main scenes/gemini/carta.tscn")
@onready var player_hand = $"../Player_Hand"

func _ready():
	draw_hand()

func draw_hand():
	for i in range(6):
		var card = card_scene.instantiate()
		
		card.scale = Vector2(0.8, 0.8)
		
		var value = randi_range(1, 9)
		
		if randf() < 0.3:
			value *= -1
		
		card.set_value(value)
		player_hand.add_child(card)
		
		var final_pos = Vector2(510 + i * 120, 650)

		# começa fora da tela
		card.position = Vector2(final_pos.x, 800)

		# define posição base CORRETA
		card.set_base_position(final_pos)

		# bloqueia clique durante animação
		card.can_click = false

		animate_card_entry(card, final_pos)


func animate_card_entry(card, target_pos):
	var tween = create_tween()
	
	var t = tween.tween_property(card, "position", target_pos, 0.4)
	t.set_trans(Tween.TRANS_BACK)
	t.set_ease(Tween.EASE_OUT)
	
	tween.tween_callback(Callable(self, "_on_card_arrived").bind(card))
	
func _on_card_arrived(card):
	card.can_click = true
	
	# GARANTE que a posição final é a base
	card.set_base_position(card.position)

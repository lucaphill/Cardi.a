extends Node2D

@onready var calculo = $"../UI/Calculo"
@onready var pontos_label = $"../UI/Pontos"
@onready var deck = $"../Deck"
@onready var enemy_label = $"../UI/Pontos_inimigo"
@onready var turn_timer = $TurnTimer
@onready var intent_label = $"../UI/Intencao"


var selected_cards = []
var score = 0
var click_lock = false
var fusion_used = false

#posiçõa das cartas na tela
var start_x = 420
var spacing = 150
var y_pos = 650
var center_offset = 850 

#vairaveis do inimigo
var enemy_score = 0
var max_score = 100
var next_enemy_action = {
	"ganha": 0,   # quanto o inimigo ganha
	"tira": 0  # quanto o jogador perde
}

func _ready():
	update_enemy_ui()
	generate_enemy_intent()

func select_card(card):
	if click_lock:
		return
		
	click_lock = true
	
	await get_tree().create_timer(0.1).timeout
	
	click_lock = false
	
	if card.selected:
		card.toggle_select()
		selected_cards.erase(card)
		update_calculo()
		return
	
	if selected_cards.size() >= 2:
		return
	
	card.toggle_select()
	selected_cards.append(card)
	
	update_calculo()

func update_calculo():
	if selected_cards.size() == 0:
		calculo.text = ""
	elif selected_cards.size() == 1:
		calculo.text = str(selected_cards[0].value)
	elif selected_cards.size() == 2:
		calculo.text = "[wave amp=20 freq=6]" + str(selected_cards[0].value) + " + " + str(selected_cards[1].value) + "[/wave]"

func finalizar_turno():
	if selected_cards.size() != 2:
		return
	
	var total = selected_cards[0].value + selected_cards[1].value
	
	if total >= 0:
		score += total
	else:
		enemy_score += total  # como total é negativo, isso diminui

	pontos_label.text = "Pontos: " + str(score)

	check_game_end()

	enemy_turn()
	
	calculo.text = str(total)
	pontos_label.text = "Pontos: " + str(score)
	
	discard_hand()
	
	turn_timer.start(1.0)
	await turn_timer.timeout
	
	deck.draw_hand()
	selected_cards.clear()
	fusion_used = false

func fundir_cartas():
	if fusion_used:
		return
		
	if selected_cards.size() != 2:
		return
	
	fusion_used = true
	
	var card1 = selected_cards[0]
	var card2 = selected_cards[1]
	
	var sum = card1.value + card2.value
	
	remove_card(card1)
	remove_card(card2)
	
	# 🔥 ESPERA 1 FRAME (IMPORTANTE)
	await get_tree().create_timer(0.05).timeout
	
	var new_card = create_card(sum)
	
	selected_cards.clear()
	update_calculo()
	
	reorganize_hand_with_animation(new_card)

func create_card(value):
	var card_scene = preload("res://scenes/main scenes/gemini/carta.tscn")
	var card = card_scene.instantiate()
	
	card.set_value(value)
	
	add_child(card)
	
	return card

func remove_card(card):
	card.is_removing = true
	selected_cards.erase(card)
	animate_card_exit(card)

func reorganize_hand():
	var valid_cards = []
	
	for c in get_children():
		if not c.is_removing:
			valid_cards.append(c)
	
	var total = valid_cards.size()
	
	# calcula largura total das cartas
	var total_width = spacing * (total - 1)
	
	# calcula início para centralizar em um ponto deslocado
	var start_x = center_offset - total_width / 2
	
	for i in range(total):
		var card = valid_cards[i]
		var new_pos = Vector2(start_x + i * spacing, y_pos)
		
		card.set_base_position(new_pos)
		
		var tween = create_tween()
		tween.tween_property(card, "position", new_pos, 0.2)

func reorganize_hand_with_animation(new_card):
	var valid_cards = []
	
	for c in get_tree().get_nodes_in_group("cards"):
		if not c.is_removing:
			valid_cards.append(c)
	
	var total = valid_cards.size()
	var total_width = spacing * (total - 1)
	var start_x = center_offset - total_width / 2
	
	for i in range(total):
		var card = valid_cards[i]
		var final_pos = Vector2(start_x + i * spacing, y_pos)
		
		if card == new_card:
			card.position = Vector2(final_pos.x, y_pos + 300)
			card.set_base_position(final_pos)
			
			var tween = create_tween()
			tween.tween_property(card, "position", final_pos, 0.3)\
				.set_trans(Tween.TRANS_BACK)\
				.set_ease(Tween.EASE_OUT)
		else:
			card.set_base_position(final_pos)
			
			var tween = create_tween()
			tween.tween_property(card, "position", final_pos, 0.2)

func discard_hand():
	for c in get_tree().get_nodes_in_group("cards"):
		animate_card_exit(c)

func _on_botao_finalizar_pressed() -> void:
	finalizar_turno()

func animate_card_exit(card):
	
	var tween = create_tween()
	
	var end_pos = card.position + Vector2(0, 400)
	
	tween.tween_property(card, "position", end_pos, 0.3)
	tween.tween_callback(card.queue_free)

func get_card_index(card):
	return get_children().find(card)

func get_total_cards():
	return get_children().size()

func _on_botao_fundir_pressed() -> void:
	fundir_cartas()

#Funções Gemini
func update_enemy_ui():
	enemy_label.text = "Inimigo: " + str(enemy_score)

func enemy_turn():
	var gain = next_enemy_action["ganha"]
	var damage = next_enemy_action["tira"]

	# inimigo ganha pontos
	enemy_score += gain

	# jogador perde pontos
	score -= damage

	# impedir valores negativos
	score = max(score, 0)

	update_enemy_ui()
	pontos_label.text = "Pontos: " + str(score)

	check_game_end()

	generate_enemy_intent()
	

func check_game_end():
		if score >= max_score:
			call_deferred("_go_to_victory")
			return
		elif enemy_score >= max_score:
			call_deferred("_go_to_defeat")

func _go_to_victory():
	if get_tree():
		get_tree().change_scene_to_file("res://scenes/vitoria.tscn")

func _go_to_defeat():
	get_tree().change_scene_to_file("res://scenes/derrota.tscn")

func generate_enemy_intent():
	var rand = randf()

	if rand < 0.5:
	# ganha pontos
		next_enemy_action = {
		"ganha": randi_range(15, 20),
		"tira": 0
		}
	elif rand < 0.9:
	# ataca jogador
		next_enemy_action = {
		"ganha": 0,
		"tira": randi_range(10, 16)
		}
	else:
	# ação híbrida 🔥
		next_enemy_action = {
		"ganha": randi_range(10, 18),
		"tira": randi_range(10, 18)
		}
	
	update_intent_ui()


func update_intent_ui():
	var gain = next_enemy_action["ganha"]
	var damage = next_enemy_action["tira"]

	if gain > 0 and damage > 0:
		intent_label.text = "Próxima ação:[pulse freq=1.0 color=green ease=-2.0]+" + str(gain) + "[/pulse] / [pulse freq=1.0 color=red ease=-2.0]-" + str(damage) + "[/pulse]"
	elif gain > 0:
		intent_label.text = "Próxima ação:[pulse freq=1.0 color=green ease=-2.0]+" + str(gain) + "[/pulse]"
	else:
		intent_label.text = "Próxima ação:[pulse freq=1.0 color=red ease=-2.0]-" + str(damage) + "[/pulse]"
		

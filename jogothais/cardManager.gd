extends Node2D

const COLLISION_MASK_CARD = 1

# definindo variaveis
var card_being_dragged
var screen_size
var is_hovering_on_card

# Pega o tamanho da tela pra empedir que a carta seja arrastada pra fora dela
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Verifica a todo frame se está clicando em alguma carta
func _process(_delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), 
			clamp(mouse_pos.y, 0, screen_size.y))


# Detecta quando o botão esquerdo for clicado 
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var card = raycast_check_for_card() # chamando a função de identificação
			if card:
				start_drag(card)
		else: 
			finish_drag()

# ANIMAÇÃO PARA QUANDO COMEÇAMOS A PEGAR UMA CARTA
func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)

func finish_drag():
	if card_being_dragged:
		card_being_dragged.scale = Vector2(1.05, 1.05)
		card_being_dragged = null
	

# conecta o sinal das cartas ao manager
func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)

# FUNÇÕES DEPENDENTES DA CONNECT CARD
func on_hovered_over_card(card):
	if !is_hovering_on_card:
		is_hovering_on_card = true
		highlight_card(card, true)
		
func on_hovered_off_card(card):
	if !card_being_dragged:
		highlight_card(card, false)
		# checando se a gente saiu de uma carta direto para a outra
		var new_card_hovered = raycast_check_for_card()
		if new_card_hovered:
			highlight_card(new_card_hovered, true)
		else:
			is_hovering_on_card = false

# Efeito de highlight (carta fica grande)
func highlight_card(card, hovered):
	if hovered:
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1


# Identifica o que esta sendo clicado
func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		#return result[0].collider.get_parent()
		return get_card_with_highest_z_index(result)
	return null

# Identifica a carta mais elevada
func get_card_with_highest_z_index(cards):
	# Vamos assumir que a primeira carta que aparece na função é a mais elevada em z
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	# agora temos que procurar no resto das cartas por uma carta com um index maior
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
			
	return highest_z_card

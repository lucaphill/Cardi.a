extends Node2D

const COLLISION_MASK_CARD = 1

# definindo variaveis
var card_being_dragged
var screen_size

# Pega o tamanho da tela pra empedir que a carta seja arrastada pra fora dela
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Verifica a todo frame se está clicando em alguma carta
func _process(delta: float) -> void:
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
				card_being_dragged = card
		else: 
			card_being_dragged = null

# Identifica o que esta sendo clicado
func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

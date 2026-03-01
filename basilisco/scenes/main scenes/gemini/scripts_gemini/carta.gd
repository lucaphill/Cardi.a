extends Node2D

var value = 0
var selected = false
var can_click = true
var tween
var base_position
var is_removing = false

func set_value(v):
	value = v
	$Sprite2D.texture = load("res://scenes/main scenes/gemini/sprites_cartas/%d.png" % v)

func _ready():
	base_position = position
	add_to_group("cards")

func toggle_select():
	selected = !selected
	
	if tween:
		tween.kill()
	
	# GARANTE que base_position está correto
	if base_position == Vector2.ZERO:
		base_position = position
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	
	var rotation = get_rotation_based_on_position()
	
	if selected:
		tween.tween_property(self, "position", base_position + Vector2(0, -30), 0.2)
		tween.parallel().tween_property(self, "scale", Vector2(1.2, 1.2), 0.2)
		tween.parallel().tween_property(self, "rotation_degrees", rotation, 0.2)
	else:
		tween.tween_property(self, "position", base_position, 0.2)
		tween.parallel().tween_property(self, "scale", Vector2(1, 1), 0.2)
		tween.parallel().tween_property(self, "rotation_degrees", 0, 0.2)

func _on_area_2d_input_event(viewport, event, shape_idx):
	if not can_click:
		return
		
	if event is InputEventMouseButton and event.pressed:
		get_parent().select_card(self)

func get_rotation_based_on_position():
	var hand = get_parent()
	
	var index = hand.get_card_index(self)
	var total = hand.get_total_cards()
	
	var middle = (total - 1) / 2.0
	
	var offset = index - middle
	
	var max_rotation = 5.0
	
	var normalized = offset / middle if middle != 0 else 0
	
	return normalized * max_rotation


func set_base_position(pos):
	base_position = pos
	

	

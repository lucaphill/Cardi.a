extends Sprite2D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func _physics_process(delta: float) -> void:
	global_position = lerp(global_position, get_global_mouse_position(), 18*delta)
	
	var desired_rotation: float
	if Input.is_action_pressed("click"):
		desired_rotation = -4.5
	else :
		desired_rotation = 0.0
		
	rotation_degrees = lerp(rotation_degrees, desired_rotation, 16.5*delta)
		
	var desired_scale
	if Input.is_action_pressed("click"):
		desired_scale = Vector2(1.1, 1.1)
	else:
		desired_scale = Vector2(1, 1)
	
	scale = lerp(scale, desired_scale, 16.5*delta)

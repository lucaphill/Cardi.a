extends Node2D
# mandando o sinal de hovered para o cardmanager
signal hovered
signal hovered_off

var hand_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Conecta a carta com o manager (TODAS AS CARTAS TEM QUE SER FILHAS DO MANAGER)
	pass

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)

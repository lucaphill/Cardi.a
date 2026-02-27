extends Node2D

@onready var calculo = $Calculo
var teste_texto = "teste"

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	calculo.text = teste_texto
	

func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main scenes/boss_select.tscn")

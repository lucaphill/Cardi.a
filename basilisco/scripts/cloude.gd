extends Node2D

@onready var musica = $MusicaClaude

func _ready() -> void:
	BackgroundMusic_menu.stop()
	musica.play()

func _on_voltar_pressed() -> void:
	musica.stop()
	BackgroundMusic_menu.play_menu_music()
	get_tree().change_scene_to_file("res://scenes/main scenes/boss_select.tscn")

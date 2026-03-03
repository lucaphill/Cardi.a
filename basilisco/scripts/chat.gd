extends Node2D
const chat_music = preload("res://assents/music/travazap2.mp3")
const main_music = preload("res://assents/music/MusicSusto.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BackgroundMusic_menu._play_music(chat_music)





func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main scenes/boss_select.tscn")
	BackgroundMusic_menu._play_music(main_music)

extends Node2D
@onready var text_derrota = $Control/derrota
const main_music = preload("res://assents/music/MusicSusto.mp3")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_derrota.text = "[wave amp=20 freq=6]" + "DERROTA" + "[/wave]"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main scenes/main_menu.tscn")
	BackgroundMusic_menu._play_music(main_music)

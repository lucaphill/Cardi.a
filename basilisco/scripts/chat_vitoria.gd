extends Node2D
const main_music = preload("res://assents/music/MusicSusto.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main scenes/main_menu.tscn")
	BackgroundMusic_menu._play_music(main_music)

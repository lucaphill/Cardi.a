extends Node2D

var button_type = null
const gemini_music = preload("res://assents/music/gemini_st.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BackgroundMusic_menu._play_music(gemini_music)
	$Trascicoes/Fade_in.hide()
	$Trascicoes/Fade_out/AnimationPlayer.play("fade_out")
	$Trascicoes/Fade_out/Fade_out_Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_desistir_pressed() -> void:
	button_type = "desistir"
	$Trascicoes/Fade_in.show()
	$Trascicoes/Fade_in/Fade_in_Timer.start()
	$Trascicoes/Fade_in/AnimationPlayer.play("fade_in")
	

func _on_fade_in_timer_timeout() -> void:
	if (button_type == "desistir"):
		get_tree().change_scene_to_file("res://scenes/main scenes/boss_select.tscn")


func _on_fade_out_timer_timeout() -> void:
	$Trascicoes/Fade_out.hide()

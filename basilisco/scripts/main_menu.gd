extends Node2D

var buttton_type = null

func _ready() -> void:
	$Transcicoes/Fade_out/AnimationPlayer.play("fade_out")
	$Transcicoes/Fade_out/Fade_out_Timer.start()
	$CanvasLayer.show()
	$botton_mannager.show()

func _on_start_pressed() -> void:
	buttton_type = "start"
	$Transcicoes/Fade_in.show()
	$Transcicoes/Fade_in/Fade_in_Timer.start()
	$Transcicoes/Fade_in/AnimationPlayer.play("fade_in")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main scenes/options.tscn")


func _on_quit_pressed() -> void:
	buttton_type = "exit"
	$Transcicoes/Fade_in.show()
	$Transcicoes/Fade_in/Fade_in_Timer.start()
	$Transcicoes/Fade_in/AnimationPlayer.play("fade_in")


func _on_fade_in_timer_timeout() -> void:
	if buttton_type == "start":
		get_tree().change_scene_to_file("res://scenes/main scenes/boss_select.tscn")
	elif buttton_type == "exit":
		get_tree().quit()


func _on_fade_out_timer_timeout() -> void:
	$Transcicoes/Fade_out.hide()

extends Node2D

var button_type = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Trascicoes/Fade_in.hide()
	$Trascicoes/Fade_out/AnimationPlayer.play("fade_out")
	$Trascicoes/Fade_out/Fade_out_Timer.start()


func _on_back_pressed() -> void:
	button_type = "voltar"
	$Trascicoes/Fade_in.show()
	$Trascicoes/Fade_in/Fade_in_Timer.start()
	$Trascicoes/Fade_in/AnimationPlayer.play("fade_in")


func _on_test_room_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main scenes/main.tscn")
	


func _on_fade_in_timer_timeout() -> void:
	if (button_type == "voltar"):
		get_tree().change_scene_to_file("res://scenes/main scenes/main_menu.tscn")
	elif (button_type == "gemini"):
		get_tree().change_scene_to_file("res://scenes/main scenes/gemini/gemini.tscn")
	elif (button_type == "chatgpt"):
		get_tree().change_scene_to_file("res://scenes/main scenes/chatgpt/chat.tscn")
	elif (button_type == "cloude"):
		get_tree().change_scene_to_file("res://scenes/main scenes/cloude/cloude.tscn")
		


func _on_fade_out_timer_timeout() -> void:
	$Trascicoes/Fade_out.hide()


func _on_button_gemini_pressed() -> void:
	button_type = "gemini"
	$Trascicoes/Fade_in.show()
	$Trascicoes/Fade_in/Fade_in_Timer.start()
	$Trascicoes/Fade_in/AnimationPlayer.play("fade_in")


func _on_button_cloud_pressed() -> void:
	button_type = "cloude"
	$Trascicoes/Fade_in.show()
	$Trascicoes/Fade_in/Fade_in_Timer.start()
	$Trascicoes/Fade_in/AnimationPlayer.play("fade_in")


func _on_button_chat_pressed() -> void:
	button_type = "chatgpt"
	$Trascicoes/Fade_in.show()
	$Trascicoes/Fade_in/Fade_in_Timer.start()
	$Trascicoes/Fade_in/AnimationPlayer.play("fade_in")

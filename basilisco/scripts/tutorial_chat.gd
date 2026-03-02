extends Control

var button_type = null

@onready var jogue_carta = $jogueUmaCarta
@onready var card_manager = $MainGPT/Chat_cardManager
@onready var cardSlot_reference = $CardSlot



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$Trascicoes/Fade_in.hide()
	$Trascicoes/Fade_out/AnimationPlayer.play("fade_out")
	$Trascicoes/Fade_out/Fade_out_Timer.start()
	jogue_carta.text = "[wave amp=20 freq=6]" + "Jogue qualquer carta para começar" + "[/wave]"


func _process(delta):
	_is_card_on_slot()


func _on_button_pressed() -> void:
	button_type = "chatgpt"
	$Trascicoes/Fade_in.show()
	$Trascicoes/Fade_in/Fade_in_Timer.start()
	$Trascicoes/Fade_in/AnimationPlayer.play("fade_in")


func _on_voltar_pressed() -> void:
	button_type = "voltar"
	$Trascicoes/Fade_in.show()
	$Trascicoes/Fade_in/Fade_in_Timer.start()
	$Trascicoes/Fade_in/AnimationPlayer.play("fade_in")


func _on_fade_in_timer_timeout() -> void:
	if (button_type == "voltar"):
		get_tree().change_scene_to_file("res://scenes/main scenes/boss_select.tscn")
		


func _on_fade_out_timer_timeout() -> void:
	$Trascicoes/Fade_out.hide()


func _is_card_on_slot():
	var card_slot_found = card_manager.raycast_check_for_card_slot()
	
	if card_slot_found and card_slot_found.card_in_slot:
		get_tree().change_scene_to_file("res://scenes/main scenes/chatgpt/chat.tscn")
		cardSlot_reference.reset_card_slot()

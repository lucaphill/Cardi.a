extends Control
const main_music = preload("res://assents/music/MusicSusto.mp3")

@onready var Display_text = $Pergunta
@onready var Option_A = $Resposta_A
@onready var Option_B = $Resposta_B
@onready var Option_C = $Resposta_C
@onready var Option_D = $Resposta_D
@onready var card_manager = $"../MainGPT/Chat_cardManager"
@onready var score = $Chat_player_points
@onready var chat_score = $ChatGPT_points
@onready var time_left = $Tempo_restante

var itens : Array = read_json_file("res://assents/perguntas.json")
var item : Dictionary
var index_item : int = 0
var score_count = 0
var chat_score_count = 0
var timer = 30

# Scrore -> definir depois


var correct_index : int

# Called when the node enters the scene tree for the first time.
func _ready():
	time_left.text = "[wave amp=20 freq=6]" + "tempo: " + str(timer) + "s"  + "[/wave]"
	
	card_manager.connect("card_played", choose_option)
	
	refresh_scene()


func refresh_scene():
	if index_item >= itens.size():
		pass
		#show_result()
	else:
		show_question()


# Transforma o Json em uma array
func read_json_file(filename):
	var file = FileAccess.open(filename, FileAccess.READ)
	
	if file == null:
		print("Erro ao abrir arquivo")
		return []
	
	var text = file.get_as_text()
	file.close()
	
	var json_data = JSON.parse_string(text)
	json_data.shuffle()
	return json_data

# Mostra a pergunta
func show_question():
	item = itens[index_item]
	
	Display_text.text = item["question"]
	
	var options = item["option"]
	
	Option_A.text = options[0]
	Option_B.text = options[1]
	Option_C.text = options[2]
	Option_D.text = options[3]
	
	correct_index = item["correct_option_index"]


# Confere se você acertou mesmo
func choose_option(selected_index: int):
	if selected_index == correct_index:
		var points = randi_range(20, 40)
		score_count += points
		score.text = "[pulse freq=1.0 color=green ease=-2.0]" + "Pontos\n+" + str(score_count)  + "[/pulse]"
		chat_score.text = "Chat GPT\n" + str(chat_score_count)
		
		# deixa o tempo verde um tico
		timer += 4
		update_timer("green")
	else:
		var chat_points = randi_range(20, 40)
		chat_score_count += chat_points
		chat_score.text = "[pulse freq=1.0 color=red ease=-2.0]" + "Chat GPT\n+" + str(chat_score_count) + "[/pulse]"
		score.text = "Pontos\n" + str(score_count)
		
		# deixa o tempo vermelho um tico
		timer -= 2
		update_timer("red")
		
	$"../CardSlot".reset_card_slot()
	index_item += 1
	$"../MainGPT/Chat_deck".refill_hand()
	refresh_scene()


func _on_timer_timeout() -> void:
	timer -= 1
	if timer <= 0:
		timer = 0
		update_timer()
		chat_game_end()
		return
		
	if timer <= 10:
		update_timer("red")
	else:
		update_timer()


func update_timer(color: String = "white"):	
	var color_tag = ""
	
	if color == "green":
		color_tag = "[pulse freq=1.0 color=green ease=-2.0]"
	elif color == "red":
		color_tag = "[pulse freq=1.0 color=red ease=-2.0]"
	
	time_left.text = color_tag + "[wave amp=20 freq=6]tempo: " + str(timer) + "s[/wave]"
	
	if color_tag != "":
		time_left.text += "[/pulse]"


func chat_game_end():
	if timer <= 0:

		if score_count > chat_score_count + 150:
			call_deferred("_go_to_victory")
			BackgroundMusic_menu._play_music(main_music)
			
		elif score_count < chat_score_count:
			call_deferred("_go_to_defeat")
			BackgroundMusic_menu._play_music(main_music)
			
		else:
			call_deferred("_go_to_defeat")
			BackgroundMusic_menu._play_music(main_music)


func _go_to_victory():
	if get_tree():
		get_tree().change_scene_to_file("res://scenes/vitoria.tscn")

func _go_to_defeat():
	if get_tree():
		get_tree().change_scene_to_file("res://scenes/derrota.tscn")

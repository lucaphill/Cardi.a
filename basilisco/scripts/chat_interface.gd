extends Control

@onready var Display_text = $Pergunta
@onready var Option_A = $Resposta_A
@onready var Option_B = $Resposta_B
@onready var Option_C = $Resposta_C
@onready var Option_D = $Resposta_D
@onready var card_manager = $"../MainGPT/Chat_cardManager"

var itens : Array = read_json_file("res://assents/perguntas.json")
var item : Dictionary
var index_item : int = 0

# Scrore -> definir depois
var correct : int = 0

var correct_index : int

# Called when the node enters the scene tree for the first time.
func _ready():
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
		print("Acertou")
		correct += 1
	else:
		print("Errou")
		
	$"../CardSlot".reset_card_slot()
	index_item += 1
	$"../MainGPT/Chat_deck".refill_hand()
	refresh_scene()

extends Control
# claude_interface.gd

@onready var fase_label     = $FaseLabel
@onready var codigo_label   = $CodigoLabel
@onready var output_label   = $OutputLabel
@onready var feedback_label = $FeedbackLabel
@onready var timer_label    = $TimerLabel
@onready var temporizador   = $Temporizador
@onready var card_manager   = $"../MainClaude/Claude_CardManager"
@onready var deck           = $"../MainClaude/Claude_Deck"
@onready var card_slot      = $"../CardSlot"

var puzzles: Array = []
var puzzle_index: int = 0
var acertos: int = 0
var tempo_restante: float = 0.0

const TOTAL_PUZZLES = 9
const TEMPO_POR_PUZZLE = 15.0 


func _ready():
	puzzles = load_json("res://assents/perguntas_claude.json")
	if puzzles.is_empty():
		push_error("ERRO: perguntas_claude.json vazio ou não encontrado!")
		return
	temporizador.timeout.connect(_on_tempo_esgotado)
	card_manager.connect("card_played", _on_card_played)
	show_puzzle()


func _process(_delta: float) -> void:
	if not temporizador.is_stopped():
		tempo_restante = temporizador.time_left
		timer_label.text = "Tempo: %d" % ceil(tempo_restante)
		
		if tempo_restante <= 5.0:
			timer_label.add_theme_color_override("font_color", Color(0.9, 0.2, 0.2))
		else:
			timer_label.add_theme_color_override("font_color", Color(0, 0.392,0.301 ))


func load_json(path: String) -> Array:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("ERRO: não encontrou o arquivo em: " + path)
		return []
	var text = file.get_as_text()
	file.close()
	var data = JSON.parse_string(text)
	if data == null:
		push_error("ERRO: JSON inválido em " + path)
		return []
	return data


func show_puzzle():
	if puzzle_index >= puzzles.size():
		end_game()
		return

	var puzzle = puzzles[puzzle_index]

	fase_label.text = "Fase %d  |  Puzzle %d/%d  |  Acertos: %d" % [
		puzzle.get("fase", 1),
		puzzle_index + 1,
		TOTAL_PUZZLES,
		acertos
	]
	codigo_label.text = puzzle.get("codigo", "")
	output_label.text = "Output: " + puzzle.get("output", "")
	feedback_label.text = ""

	# Inicia o timer
	temporizador.wait_time = 10
	temporizador.one_shot = true
	temporizador.start()

	deck.refill_hand(puzzle.get("cartas", []))


func _on_card_played(option_index: int):
	temporizador.stop()
	var puzzle = puzzles[puzzle_index]

	if option_index == puzzle.get("correta", -1):
		feedback_label.text = "✓ Correto!"
		feedback_label.add_theme_color_override("font_color", Color(0.2, 0.9, 0.2))
		acertos += 1
	else:
		feedback_label.text = "✗ Errado!"
		feedback_label.add_theme_color_override("font_color", Color(0.9, 0.2, 0.2))

	await get_tree().create_timer(1.5).timeout
	card_slot.reset_card_slot()
	puzzle_index += 1
	show_puzzle()


func _on_tempo_esgotado():
	feedback_label.text = "⏱ Tempo esgotado!"
	feedback_label.add_theme_color_override("font_color", Color(1.0, 0.6, 0.0))

	await get_tree().create_timer(1.5).timeout
	card_slot.reset_card_slot()
	puzzle_index += 1
	show_puzzle()


func end_game():
	if acertos >= 7:
		get_tree().change_scene_to_file("res://scenes/vitoria.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/derrota.tscn")

extends Node2D

# Grupo: "npc_niede"
#flags
var player_nearby = false
var player_ref = null
var dialog_active = false
var dialog_index = 0
var post_puzzle = false
var puzzle_done = false
var puzzle_started = false
var no_paper_dialog = false

#var dos textos
var full_text = ""
var current_text = ""
var char_index = 0
var typing = false
var typing_speed = 0.05
var typing_timer = 0.0

var dialogs_before = [
	"Entao voce e o agente que a Agencia enviou...",
	"Sou Niede Guidon. Estudei estas cavernas por anos.",
	"Dinossauros surgiram aqui... mas nao sao violentos.",
	"O problema sao os puzzles que eles criaram.",
	"Precisamos entende-los para manter a paz.",
	"Mas primeiro... prove que voce e capaz."
]

var dialogs_after = [
	"Voce conseguiu.",
	"Os dinossauros criaram esses puzzles",
	"Talvez para encontrar alguem inteligente.",
	"Ha um dinossauro aqui... curioso e obcecado por puzzles.",
	"Se ele confiar em voce, existe esperanca para todos nos.",
	"Pode passar agora."
]

var dialogs_repeat = [
	"Preserve as pinturas, jovem.",
	"Este parque é patrimonio mundial.",
	"Vou lhe acompanhar"
]

var dialog_finished = false

@onready var interact_hint = $InteractHint
@onready var dialog_bubble = $DialogBubble
@onready var dialog_label = $DialogBubble/Panel/Label
@onready var npc_sprite = $AnimatedSprite2D

func _ready():
	add_to_group("npc_niede")
	interact_hint.visible = false
	dialog_bubble.visible = false

func _physics_process(delta):
	if typing:
		typing_timer += delta
		if typing_timer >= typing_speed:
			typing_timer = 0.0
			if char_index < full_text.length():
				current_text += full_text[char_index]
				dialog_label.text = current_text
				char_index += 1
			else:
				typing = false

func _process(_delta):
	if get_tree().get_first_node_in_group("puzzle_layer") != null:
		return
	if player_nearby and player_ref:
		interact_hint.visible = player_ref.is_on_floor()
	if player_nearby and player_ref and player_ref.is_on_floor():
		if Input.is_action_just_pressed("interact"):
			if not dialog_active:
				_check_and_start_dialog()
			else:
				advance_dialog()

func _check_and_start_dialog():
	if not ReferenceGlobal.collected_items["tutorial_niede_paper"]:
		dialog_active = true
		no_paper_dialog = true
		interact_hint.visible = false
		dialog_bubble.visible = true
		get_tree().paused = true
		show_dialog("Encontre o papiro sobre pinturas rupestres primeiro!")
		return
	start_dialog()

func start_dialog():
	if dialog_finished:
		post_puzzle = false
		dialog_index = 0
		dialog_active = true
		interact_hint.visible = false
		dialog_bubble.visible = true
		show_dialog(dialogs_repeat[dialog_index])
		return
	dialog_active = true
	dialog_index = 0
	post_puzzle = false
	interact_hint.visible = false
	dialog_bubble.visible = true
	get_tree().paused = true
	npc_sprite.speed_scale = 1.0
	show_dialog(dialogs_before[dialog_index])

func advance_dialog():
	if typing:
		typing = false
		dialog_label.text = full_text
		return

	if no_paper_dialog:
		no_paper_dialog = false
		dialog_bubble.visible = false
		dialog_active = false
		get_tree().paused = false
		return

	dialog_index += 1

	if dialog_finished:
		if dialog_index >= dialogs_repeat.size():
			end_dialog_repeat()
			return
		show_dialog(dialogs_repeat[dialog_index])
		return

	if not post_puzzle:
		if dialog_index >= dialogs_before.size():
			dialog_bubble.visible = false
			dialog_active = false
			get_tree().paused = false
			if not puzzle_started:
				puzzle_started = true
				Puzzle.start_puzzle("tutorial_niede")
			return
		show_dialog(dialogs_before[dialog_index])
	else:
		if dialog_index >= dialogs_after.size():
			end_dialog()
			return
		show_dialog(dialogs_after[dialog_index])

func show_dialog(text: String):
	dialog_label.text = ""
	full_text = text
	current_text = ""
	char_index = 0
	typing_timer = 0.0
	typing = true

func start_post_puzzle_dialog():
	if puzzle_done:
		return
	post_puzzle = true
	dialog_index = 0
	dialog_bubble.visible = true
	dialog_active = true
	show_dialog(dialogs_after[dialog_index])

func end_dialog():
	dialog_finished = true
	puzzle_done = true
	dialog_bubble.visible = false
	dialog_active = false
	get_tree().paused = false

func end_dialog_repeat():
	dialog_bubble.visible = false
	dialog_active = false
	get_tree().paused = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_ref = body
		player_nearby = true
		interact_hint.visible = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_ref = null
		player_nearby = false
		if not dialog_active:
			interact_hint.visible = false

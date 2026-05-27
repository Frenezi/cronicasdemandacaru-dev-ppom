extends Node2D

var player_nearby = false
var dialog_active = false
var dialog_index = 0
var dialog_finished = false

var full_text = ""
var current_text = ""
var char_index = 0
var typing = false
var typing_speed = 0.05
var typing_timer = 0.0

var dialogs = [
	"Olá!",
	"Eu sou Niéde Guidon",
	"Aqui é um lugar perigoso!",
	"Se planeja avancar",
	"Conte comigo!",
	"A frente tem uma caverna",
	"Só que ela está bloqueada",
	"Se voce encontrar um dinossauro, talvez ele consiga abrir",
	"Enfim, te encontro lá na entrada!"
]

var dialogs_repeat = [
	"Me encontre lá na caverna",
    "Acho que vou ter novas pistas..."
]

@onready var interact_hint = $InteractHint
@onready var dialog_bubble = $DialogBubble
@onready var dialog_label = $DialogBubble/Panel/Label
@onready var npc_sprite = $AnimatedSprite2D

func _ready():
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
	if player_nearby and not dialog_active:
		if Input.is_action_just_pressed("interact"):
			start_dialog()
	elif dialog_active:
		if Input.is_action_just_pressed("interact"):
			advance_dialog()

func start_dialog():
	if dialog_finished:
		dialog_index = 0
		dialog_active = true
		interact_hint.visible = false
		dialog_bubble.visible = true
		get_tree().paused = true
		show_dialog(dialogs_repeat[dialog_index])
		return

	dialog_active = true
	dialog_index = 0
	interact_hint.visible = false
	dialog_bubble.visible = true
	get_tree().paused = true
	show_dialog(dialogs[dialog_index])

func advance_dialog():
	if typing:
		typing = false
		dialog_label.text = full_text
		return

	dialog_index += 1

	if dialog_finished:
		if dialog_index >= dialogs_repeat.size():
			end_dialog()
			return
		show_dialog(dialogs_repeat[dialog_index])
		return

	if dialog_index >= dialogs.size():
		end_dialog()
		return

	show_dialog(dialogs[dialog_index])

func show_dialog(text: String):
	dialog_label.text = ""
	full_text = text
	current_text = ""
	char_index = 0
	typing_timer = 0.0
	typing = true

func end_dialog():
	dialog_finished = true
	dialog_bubble.visible = false
	dialog_active = false
	get_tree().paused = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true
		interact_hint.visible = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
		if not dialog_active:
			interact_hint.visible = false

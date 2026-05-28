extends CanvasLayer

var callback_when_done = null
var fade_duration = 2
var fading_out = false

@onready var puzzle_screen = $ColorRect
@onready var question_label = $ColorRect/Panel/Pergunta
@onready var error_label = $ColorRect/Panel/Error
@onready var btn = $ColorRect/Panel/Confirm

# Slots — onde o jogador vai soltar os blocos
@onready var slot1 = $ColorRect/Panel/Slots/Slot1
@onready var slot2 = $ColorRect/Panel/Slots/Slot2

# Blocos arrastáveis
@onready var bloco1 = $ColorRect/Panel/Blocos/Bloco1
@onready var bloco2 = $ColorRect/Panel/Blocos/Bloco2

# Dados do puzzle
var slot1_answer := ""
var slot2_answer := ""
var slot1_current := ""   # o que está no slot1 agora
var slot2_current := ""   # o que está no slot2 agora

# Controle do drag
var dragging = null        # bloco sendo arrastado
var drag_offset = Vector2()


func _physics_process(_delta):
	if fading_out:
		print("FADING: ", puzzle_screen.modulate.a)
		puzzle_screen.modulate.a -= 0.03  # velocidade do fade
		if puzzle_screen.modulate.a <= 0:
			puzzle_screen.modulate.a = 0
			queue_free()
func setup(question: String, answers: Array, blocks: Array, callback: Callable):
	callback_when_done = callback
	question_label.text = question

	slot1.expected_answer = blocks[0]  # ← era answers[0]
	slot2.expected_answer = blocks[1]  # ← era answers[1]

	slot1.get_node("VBoxContainer/Label").text = answers[0]  # descrição continua igual
	slot2.get_node("VBoxContainer/Label").text = answers[1]

	slot1.get_node("VBoxContainer/DropArea/Label").text = "Arraste o bloco \n aqui"
	slot1.get_node("VBoxContainer/DropArea/Label").visible = true
	slot2.get_node("VBoxContainer/DropArea/Label").text = "Arraste o bloco \n aqui "
	slot2.get_node("VBoxContainer/DropArea/Label").visible = true
	
	bloco1.get_node("Label").text = blocks[0]
	bloco2.get_node("Label").text = blocks[1]

	error_label.visible = false
	_update_button()
	fade_in()

func _ready():
	$ColorRect/Panel/BotaoReset.pressed.connect(_reset_slots)
	$ColorRect/Panel/BotaoReferencia.pressed.connect(_open_reference)
	add_to_group("puzzle_layer")
	btn.connect("pressed", Callable(self, "_on_confirm"))

func _update_button():
	# Fica verde só quando os dois slots estiverem preenchidos
	var filled = slot1_current != "" and slot2_current != ""
	btn.modulate = Color.GREEN if filled else Color.WHITE

func _on_confirm():
	if slot1_current == "" or slot2_current == "":
		return  # botão inativo, ignora
	print("Slot1 current: ", slot1.current_block)
	print("Slot1 expected: ", slot1.expected_answer)
	print("Slot2 current: ", slot2.current_block)
	print("Slot2 expected: ", slot2.expected_answer)

	# Verifica se cada bloco está no slot certo
	var correct = (slot1.current_block == slot1.expected_answer 
					and slot2.current_block == slot2.expected_answer)

	if correct:
		callback_when_done.call()
		fade_out()
	else:
		error_label.text = "Bloco no lugar errado!"
		error_label.visible = true
		var tween = create_tween()
		tween.tween_property(error_label, "modulate:a", 0, fade_duration)
		await get_tree().create_timer(fade_duration, true, false, true).timeout
		print("TWEEN ACABOU!")
		error_label.visible = false
 # Reexibe os blocos e limpa os slots
		_reset_slots()

func _reset_slots():
	# Limpa os slots
	slot1.current_block = ""
	slot2.current_block = ""
	slot1_current = ""
	slot2_current = ""
	slot1.get_node("VBoxContainer/DropArea/Label").text = ""
	slot1.get_node("VBoxContainer/DropArea/Label").visible = false
	slot2.get_node("VBoxContainer/DropArea/Label").text = ""
	slot2.get_node("VBoxContainer/DropArea/Label").visible = false
	
	# Reexibe os blocos
	bloco1.visible = true
	bloco2.visible = true
	bloco1.modulate.a = 1.0
	bloco2.modulate.a = 1.0
	
	_update_button()

func _on_slot_changed():
	slot1_current = slot1.current_block
	slot2_current = slot2.current_block
	print("Slot1: ", slot1_current)  # ← aparece algo?
	print("Slot2: ", slot2_current)
	_update_button()

func hide_bloco(block_text: String):
	if bloco1.get_node("Label").text == block_text:
		bloco1.visible = false
	elif bloco2.get_node("Label").text == block_text:
		bloco2.visible = false

func _open_reference():
	var ref_screen = get_tree().get_first_node_in_group("reference_screen")
	ref_screen.open("dica_2")
func fade_in():
	var tw = create_tween()
	tw.tween_property(puzzle_screen, "modulate:a", 0.8, 0.7)

func fade_out():
	fading_out = true

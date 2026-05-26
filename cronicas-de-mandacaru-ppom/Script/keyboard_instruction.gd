extends Node2D
@onready var player = get_tree().get_first_node_in_group("player") 
@onready var label = $Label
@onready var anim_a = $"A - ANIM"
@onready var anim_d = $"D - ANIM"
@onready var anim_s = $"S - ANIM"
@onready var anim_w = $"W - ANIM"
var current_instruction = ""
var current_tween = null
var is_hiding = false
func _ready():
	add_to_group("keyboard_instruction")
	print("KEYBOARD INSTRUCTION PRONTO!")
	show_instruction("d")  # começa com D

func hide_all_keys():
	anim_a.stop()
	anim_d.stop()
	anim_s.stop()
	anim_w.stop()
	anim_a.frame = 0
	anim_d.frame = 0
	anim_s.frame = 0
	anim_w.frame = 0
	print("A frame depois do reset: ", anim_a.frame)
	anim_a.visible = true
	anim_d.visible = true
	anim_s.visible = true
	anim_w.visible = true
	
func hide_instruction():
	is_hiding = true
	current_tween = create_tween()
	current_tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await current_tween.finished
	if is_hiding:
		visible = false
		modulate.a = 1.0
	is_hiding = false
func show_instruction(type: String):
	is_hiding = false
	if current_tween:
		current_tween.kill()
	current_instruction = type
	visible = true
	modulate.a = 1.0
	hide_all_keys()
	match type:
		"d":
			anim_d.play() 
			label.text = "Segure D para andar -->"
			position = Vector2(200, -30 )  # ← posição na tela
		"s":
			anim_s.play()
			label.text = "Segure S para cair"
			position = Vector2(30, 180)  # ← outra posição
		"w_a":
			anim_w.play()
			anim_a.play()
			label.text = "Segure W e A para pular esta plataforma!"
			position = Vector2(120, 85)
		"a":
			anim_a.play()
			label.text = "Segure A para andar <--"
			position = Vector2(290, 80)
		"end":
			hide_instruction()

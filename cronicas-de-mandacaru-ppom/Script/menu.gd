extends Control

@onready var bt_play = $TextureButton
@onready var bt_opcoes = $TextureButton2
@onready var bt_sair = $TextureButton3

var posicoes_originais = {}

func _ready():
	bt_play.pressed.connect(_on_play)
	bt_opcoes.pressed.connect(_on_opcoes)
	bt_sair.pressed.connect(_on_sair)
	
	for bt in [bt_play, bt_opcoes, bt_sair]:
		posicoes_originais[bt] = bt.position
		bt.mouse_entered.connect(_on_hover.bind(bt))
		bt.mouse_exited.connect(_on_unhover.bind(bt))

func _on_hover(bt):
	var tween = create_tween().set_parallel(true)
	tween.tween_property(bt, "scale", Vector2(0.37, 0.37), 0.15)
	tween.tween_property(bt, "position", posicoes_originais[bt] + Vector2(-3, 0), 0.15)

func _on_unhover(bt):
	var tween = create_tween().set_parallel(true)
	tween.tween_property(bt, "scale", Vector2(0.35, 0.35), 0.15)
	tween.tween_property(bt, "position", posicoes_originais[bt], 0.15)

func _on_play():
	get_tree().change_scene_to_file("res://Scene/cutscene.tscn")

func _on_opcoes():
	get_tree().change_scene_to_file("res://Scene/menu_opcs.tscn")

func _on_sair():
	get_tree().quit()

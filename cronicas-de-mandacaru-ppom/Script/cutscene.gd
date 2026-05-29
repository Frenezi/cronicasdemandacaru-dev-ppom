extends Control

const SCENE_DATA = [
{"path": "res://cutscene/cutscene_t1.png", "text": "Era uma noite tranquila... Mandacaru, o Tamandua-bandeira, descansava sem imaginar o que estava por vir."},
{"path": "res://cutscene/cutscene_t2.png", "text": "Um alerta da ACT - Agencia de Correcao de Bugs. Mandacaru recebeu uma missao: investigar bugs criticos no Parque Nacional da Serra da Capivara."},
{"path": "res://cutscene/cutscene_t3.png", "text": "Mandacaru chegou ao parque sob a lua crescente. O lugar parecia normal... mas algo estava errado."},
{"path": "res://cutscene/cutscene_t4.png", "text": "Criaturas impossiveis emergiram das rochas. Os bugs haviam corrompido a realidade do parque. Mandacaru ficou paralisado de medo."},
{"path": "res://cutscene/cutscene_t5.png", "text": "Distraido pelas silhuetas das criaturas, Mandacaru escorregou e caiu numa caverna escura. La embaixo... a missao havia apenas comecado."},
]

@onready var cutscene_image = $CutsceneFrame/TextureRect
@onready var cutscene_text = $CutsceneFrame/CutsceneText
@onready var animator = $AnimationPlayer
@onready var fade_screen = $FadeScreen
@onready var musica = $AudioStreamPlayer2D
@onready var skip_button = $SkipButton
var skipped = false

const SCENE_MIN_TIME = 5.0
const TYPEWRITER_SPEED = 0.07

func do_fade_in():
	cutscene_text.visible = false
	animator.play("fade_out")
	await animator.animation_finished
	cutscene_text.visible = true

func do_fade_out():
	cutscene_text.visible = false
	animator.play("fade_in")
	await animator.animation_finished

func show_text_typewriter(text_to_show: String) -> float:
	cutscene_text.clear()
	var total_time := 0.0
	for i in range(text_to_show.length()):
		cutscene_text.append_text(text_to_show[i])
		await get_tree().create_timer(TYPEWRITER_SPEED).timeout
		total_time += TYPEWRITER_SPEED
	var extra_pause := 1.0
	await get_tree().create_timer(extra_pause).timeout
	return total_time + extra_pause

func _ready():
	fade_screen.modulate.a = 0.0
	musica.play()
	skip_button.pressed.connect(_skip_cutscene)
	start_cutscene()
	
func _skip_cutscene():
	if skipped:
		return
	skipped = true
	end_cutscene()	

func start_cutscene():
	var scene = SCENE_DATA[0]
	cutscene_image.texture = load(scene.path)
	await do_fade_in()
	var spent = await show_text_typewriter(scene.text)
	if spent < SCENE_MIN_TIME:
		await get_tree().create_timer(SCENE_MIN_TIME - spent).timeout

	for i in range(1, SCENE_DATA.size()):
		var data = SCENE_DATA[i]
		await do_fade_out()
		cutscene_image.texture = load(data.path)
		await do_fade_in()
		spent = await show_text_typewriter(data.text)
		if spent < SCENE_MIN_TIME:
			await get_tree().create_timer(SCENE_MIN_TIME - spent).timeout

	await do_fade_out()
	end_cutscene()

func end_cutscene():
	musica.stop()
	print("Cutscene Terminada! Carregando o jogo...")
	var next_scene = load("res://Scene/tutorial.tscn")
	get_tree().change_scene_to_packed(next_scene)

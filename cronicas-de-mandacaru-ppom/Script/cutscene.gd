extends Control

# ----------------------------------------------------
# DADOS DA CUTSCENE
# ----------------------------------------------------
const SCENE_DATA = [
	{"path": "res://cutscene/cutscene_t1.png", "text": "Era uma noite tranquila para Mandacaru o Tatu-bandeira descansava sem imaginar o que estava por vir..."},
	{"path": "res://cutscene/cutscene_t2.png", "text": "Um alerta da ACT(Agência de Correção de Bugs). Mandacaru recebeu uma missão: investigar uma série de bugs críticos reportados no Parque Nacional da Serra da Capivara."},
	{"path": "res://cutscene/cutscene_t3.png", "text": "Mandacaru chegou ao parque sob a lua crescente. O lugar parecia normal... mas algo estava errado."},
	{"path": "res://cutscene/cutscene_t4.png", "text":  "Criaturas impossíveis emergiram das rochas, os bugs haviam corrompido a própria realidade do parque. Mandacaru ficou paralisado de medo."},
	{"path": "res://cutscene/cutscene_t5.png", "text": "Distraído pelas silhuetas das criaturas, Mandacaru escorregou e caiu numa caverna escura. Lá embaixo... a missão havia apenas começado."}
]

# ----------------------------------------------------
# NÓS
# ----------------------------------------------------
@onready var cutscene_image = $CutsceneFrame/TextureRect
@onready var cutscene_text = $CutsceneFrame/CutsceneText
@onready var animator = $AnimationPlayer
@onready var fade_screen = $FadeScreen

# ----------------------------------------------------
# PARÂMETROS
# ----------------------------------------------------
const SCENE_MIN_TIME = 5.0      # tempo mínimo que cada cena deve durar
const TYPEWRITER_SPEED = 0.07   # velocidade da digitação

# ----------------------------------------------------
# FADE
# ----------------------------------------------------
func do_fade_in():
	cutscene_text.visible = false
	animator.play("fade_out")  # fade_out = ir do preto → transparente
	await animator.animation_finished
	cutscene_text.visible = true
func do_fade_out():
	cutscene_text.visible = false
	animator.play("fade_in")   # fade_in = ir da transparência → preto
	await animator.animation_finished

# ----------------------------------------------------
# TYPEWRITER (retorna quanto tempo levou)
# ----------------------------------------------------
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

# ----------------------------------------------------
# READY
# ----------------------------------------------------
func _ready():
	# começa transparente
	fade_screen.modulate.a = 0.0
	start_cutscene()


# ----------------------------------------------------
# EXECUÇÃO DA CUTSCENE
# ----------------------------------------------------
func start_cutscene():

	# ------- PRIMEIRA CENA -------
	var scene = SCENE_DATA[0]
	cutscene_image.texture = load(scene.path)

	# fade in
	await do_fade_in()

	# texto + tempo gasto
	var spent = await show_text_typewriter(scene.text)

	# garante tempo mínimo
	if spent < SCENE_MIN_TIME:
		await get_tree().create_timer(SCENE_MIN_TIME - spent).timeout


	# ------- RESTO DAS CENAS -------
	for i in range(1, SCENE_DATA.size()):
		var data = SCENE_DATA[i]

		# fade out da imagem atual
		await do_fade_out()

		# troca enquanto está preto
		cutscene_image.texture = load(data.path)

		# fade in da próxima
		await do_fade_in()

		# exibe texto e calcula tempo
		spent = await show_text_typewriter(data.text)

		# garante tempo mínimo
		if spent < SCENE_MIN_TIME:
			await get_tree().create_timer(SCENE_MIN_TIME - spent).timeout


	# ------- FINAL -------
	await do_fade_out()
	end_cutscene()


# ----------------------------------------------------
# PÓS-CUTSCENE
# ----------------------------------------------------
func end_cutscene():
	print("Cutscene Terminada! Carregando o jogo...")

	var next_scene = load("res://Scene/fase1.tscn")
	get_tree().change_scene_to_packed(next_scene)

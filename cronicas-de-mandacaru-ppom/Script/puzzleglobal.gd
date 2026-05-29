extends Node
 
@onready var puzzle_ui_scene := preload("res://Scene/puzzle_layer.tscn")
 
# ─── RECOMPENSAS ───────────────────────────────────────────────────────────────
 
func reward_notebook_1():
	print("Player ganhou buff: +10 HP!")
	get_tree().change_scene_to_file("res://Scene/ending.tscn")
 
func reward_notebook_2():
	var player = get_tree().get_first_node_in_group("player")
	player.blocked = true
	get_tree().paused = false
	await get_tree().create_timer(0.8).timeout
	get_tree().paused = true
	player.blocked = false
	var npc = get_tree().get_first_node_in_group("npc")
	npc.start_post_puzzle_dialog()
 
func reward_niede():
	var player = get_tree().get_first_node_in_group("player")
	player.blocked = true
	get_tree().paused = false
	await get_tree().create_timer(0.8).timeout
	get_tree().paused = true
	player.blocked = false
	var npc = get_tree().get_first_node_in_group("npc_niede")
	if npc:
		npc.start_post_puzzle_dialog()
 
# ─── PUZZLES ───────────────────────────────────────────────────────────────────
 
var puzzles = {
	"notebook_1": {
		"question": "Print, um comando de saída!",
		"slot_labels": [
			"--> EU QUERO UM BLOCO QUE MOSTRE: Miguel",
			"--> EU QUERO UM BLOCO QUE MOSTRE: Olá mundo!"
		],
		"blocks": [
			'print("Miguel")',
			'print("Olá mundo!")'
		],
		"reference_id": "saida",
		"reward": Callable(self, "reward_notebook_1")
	},
	"notebook_2": {
		"question": "Variáveis, caixas que guardam tudo!",
		"slot_labels": [
			"--> EU QUERO UM BLOCO EM QUE X RECEBE 15",
			"--> EU QUERO UM BLOCO EM QUE X RECEBE: \"Ana\""
		],
		"blocks": [
			'X = 15',
			'X = "Ana"'
		],
		"reference_id": "variaveis",
		"reward": Callable(self, "reward_notebook_2")
	},
	"tutorial_niede": {
		"question": "A Serra da Capivara - Maravilha Arqueológica!",
		"slot_labels": [
			"--> A SERRA DA CAPIVARA É O QUE?",
			"--> EM QUAL ESTADO FICA A SERRA DA CAPIVARA?"
		],
		"blocks": [
			"Patrimonio Cultural",
			"Piauí"
		],
		"reference_id": "pinturas",
		"reward": Callable(self, "reward_niede")
	}
}
 
# ─── INICIAR PUZZLE ────────────────────────────────────────────────────────────
 
func start_puzzle(puzzle_id: String, _npc = null):
	if not puzzles.has(puzzle_id):
		push_warning("Puzzle não existe: " + puzzle_id)
		return
	var data = puzzles[puzzle_id]
	get_tree().paused = true
	var ui = puzzle_ui_scene.instantiate()
	get_tree().current_scene.add_child(ui)
	ui.setup(
		data.question,
		data.slot_labels,
		data.blocks,
		data.get("reference_id", ""),
		func():
			get_tree().paused = false
			data.reward.call()
	)

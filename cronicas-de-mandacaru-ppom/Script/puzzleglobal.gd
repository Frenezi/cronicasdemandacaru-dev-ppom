extends Node

@onready var puzzle_ui_scene := preload("res://Scene/puzzle_layer.tscn")

func reward_notebook_1():
	print("Player ganhou buff: +10 HP!")
func reward_notebook_2():
	var player = get_tree().get_first_node_in_group("player")
	player.blocked = true
	get_tree().paused = false
	await get_tree().create_timer(0.8).timeout  # espera o fade (0.7s) terminar
	get_tree().paused = true
	player.blocked = false
	var npc = get_tree().get_first_node_in_group("npc")
	npc.start_post_puzzle_dialog()




var puzzles = {
	"notebook_1": {
		"question": "Print, um comando de saída!",
		"slot_labels": [
			"--> EU QUERO UM BLOCO QUE MOSTRE: ",
            "--> EU QUERO UM BLOCO QUE MOSTRE: Olá mundo!"
		],
		"blocks": [
			'print("Bruno")',
            'print("Olá mundo!")'
		],
		"reward": Callable(self, "reward_notebook_1")
	},
	"notebook_2": {
		"question": "As variáveis na linguagem Python guardam valores, exemplo:
			nome = \"Ana\", nome é a caixa, \"Ana\" é o valor guardado!",
		"slot_labels": [
			"--> BLOCO EM QUE X É 15",
			"--> BLOCO EM QUE X: \"Bruno\""
		],
		"blocks": [
			'X = 15',
			'X = \"Bruno\"'
		],
		 "reward": Callable(self, "reward_notebook_2")  # ← faltou isso
}
}

func start_puzzle(puzzle_id: String):
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
		func():
			get_tree().paused = false
			data.reward.call()
	)

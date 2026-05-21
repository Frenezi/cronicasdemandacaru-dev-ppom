extends Node

@onready var puzzle_ui_scene := preload("res://Scene/puzzle_layer.tscn")

func reward_notebook_1():
	print("Player ganhou buff: +10 HP!")


var puzzles = {
	"notebook_1": {
		"question": "Em python, qual o comando para que a saída seja: Hello World!",
		"answer": "print('Hello World!')",
		"reward": Callable(self, "reward_notebook_1")
	},
	"notebook_2": {
		"question": "Em python, qual o comando para declarar que a variável X recebe 67?",
		"answer": "x = 15",
		"reward": Callable(self, "reward_notebook_1")
	}
}

func start_puzzle(puzzle_id: String):
	if not puzzles.has(puzzle_id):
		push_warning("Puzzle não existe: " + puzzle_id)
		return

	var data = puzzles[puzzle_id]

	Engine.time_scale = 0.0  # pausa o jogo

	var ui = puzzle_ui_scene.instantiate()
	get_tree().current_scene.add_child(ui)

	ui.setup(
		data.question,
		data.answer,
		func():
			Engine.time_scale = 1.0  # despausa
			data.reward.call()
	)

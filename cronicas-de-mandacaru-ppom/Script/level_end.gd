extends Area2D

# Lista de cenas em ordem
const SCENES = [
	"res://Scene/tutorial.tscn",
	"res://Scene/tropic.tscn",
	"res://Scene/forest.tscn",
	"res://Scene/cave.tscn",
	# adiciona mais cenas aqui na ordem que quiser
]

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var current = get_tree().current_scene.scene_file_path
		var index = SCENES.find(current)
		
		if index != -1 and index + 1 < SCENES.size():
			var next = SCENES[index + 1]
			print("Indo para próxima cena:", next)
			Transition.next_scene = next
			Transition.fade_out()
		else:
			push_warning("Não há próxima cena! Você está na última.")

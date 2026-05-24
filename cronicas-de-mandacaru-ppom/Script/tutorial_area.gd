extends Area2D

@export var instruction_type: String = "d"  # muda no editor para cada área
var player_inside = false


func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited" , Callable(self, "_on_body_exited"))
	
func _on_body_entered(body):
	print("ENTROU NA AREA: ", body.name)
	if body.is_in_group("player"):
		player_inside = true
		var kb = get_tree().get_first_node_in_group("keyboard_instruction")
		print("KB encontrado: ", kb)  # ← aparece null ou o nó?
		kb.show_instruction(instruction_type)
		
func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		await get_tree().create_timer(0.1).timeout
		if not player_inside:
			var kb = get_tree().get_first_node_in_group("keyboard_instruction")
			if kb.current_instruction == instruction_type:
				kb.hide_instruction()

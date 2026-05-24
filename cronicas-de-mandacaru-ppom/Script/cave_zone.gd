extends Area2D

@export var cave_floor_y: float = -220.0

var camera: Camera2D

func _ready() -> void:
	camera = get_tree().get_first_node_in_group("camera")
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	camera.enter_cave(cave_floor_y)

func _on_body_exited(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	camera.exit_cave()

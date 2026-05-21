extends Camera2D

var target: Node2D

func _ready() -> void:
	get_target()

func _process(_delta: float) -> void:
	position = target.position

func get_target():
	var nodes = get_tree().get_nodes_in_group("player")
	if nodes.size() == 0:
		push_error("player not found")
		return
	target = nodes[0]

func enter_cave(floor_y: float) -> void:
	var tween = create_tween()
	tween.tween_property(self, "limit_bottom", int(floor_y), 1.0)

func exit_cave() -> void:
	var tween = create_tween()
	tween.tween_property(self, "limit_bottom", 10000000, 1.0)

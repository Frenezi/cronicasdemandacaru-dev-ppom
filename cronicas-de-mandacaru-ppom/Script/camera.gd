extends Camera2D

var target: Node2D
var original_limit_bottom: int = 208

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
	tween.tween_property(self, "limit_bottom", int(floor_y), 0.8)

func exit_cave() -> void:
	var tween = create_tween()
	tween.tween_property(self, "limit_bottom", original_limit_bottom, 0.8)

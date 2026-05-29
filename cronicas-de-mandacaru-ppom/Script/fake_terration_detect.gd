extends Area2D

var tween: Tween

@export var terrain_node: TileMapLayer

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.name == "Player":
		_fade_caverna(0.3)

func _on_body_exited(body):
	if body.name == "Player":
		_fade_caverna(1.0)

func _fade_caverna(alpha: float):
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(terrain_node, "modulate:a", alpha, 0.5)

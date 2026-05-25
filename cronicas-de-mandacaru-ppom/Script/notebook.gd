extends Area2D
@onready var target: Sprite2D = $Target
var comeback_duration = 1
var fade_duration = 1
@onready var sprite: Sprite2D = $Sprite2D
@export var puzzle_id := "notebook_1"  # caso tenha várias charadas no jogo


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	target.visible = false
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "global_position", target.global_position, comeback_duration)
	tween.tween_property(self, "global_position", global_position, comeback_duration)
	tween.set_loops()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		var fade_tween = create_tween()
		fade_tween.tween_property(sprite, "modulate:a", 0, fade_duration)
		await get_tree().create_timer(fade_duration).timeout
		queue_free()
		Puzzle.start_puzzle(puzzle_id)

	

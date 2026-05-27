extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.velocity.x = 0
		body.blocked = true
		await get_tree().create_timer(0.1).timeout
		body.blocked = false

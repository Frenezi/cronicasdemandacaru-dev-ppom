extends Node2D

@onready var interior = $Interior  # aponta pro nó novo

func _on_detector_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		interior.visible = true

func _on_detector_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		interior.visible = false

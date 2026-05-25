extends Panel

func _get_drag_data(at_position: Vector2):
	var preview = Label.new()
	preview.text = $Label.text
	set_drag_preview(preview)
	modulate.a = 0.0  # ← fica transparente durante o drag
	
	# Retorna o texto do bloco como dado do drag
	return $Label.text

func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		modulate.a = 1.0  
	

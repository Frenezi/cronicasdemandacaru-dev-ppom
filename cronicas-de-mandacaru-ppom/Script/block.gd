extends Panel

func _get_drag_data(at_position: Vector2):
	var preview = Panel.new()
	preview.custom_minimum_size = Vector2(120, 40)
	preview.size = Vector2(120, 40)
	
	var style = get_theme_stylebox("panel").duplicate()
	preview.add_theme_stylebox_override("panel", style)
	
	var label = Label.new()
	label.text = $Label.text
	label.add_theme_font_override("font", $Label.get_theme_font("font"))
	label.add_theme_font_size_override("font_size", $Label.get_theme_font_size("font_size"))
	label.add_theme_color_override("font_color", $Label.get_theme_color("font_color"))
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size = preview.size  # ← ocupa todo o painel
	preview.add_child(label)
	
	set_drag_preview(preview)
	modulate.a = 0.0
	return $Label.text

func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		modulate.a = 1.0

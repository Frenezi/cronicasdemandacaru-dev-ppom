extends Area2D

@export var message_duration: float = 2.5
@export var game_font: Font  # ← arrasta a fonte aqui no Inspector

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return

	var niede = get_tree().get_first_node_in_group("npc_niede")
	if niede and not niede.puzzle_done:
		_show_message("Acho que eu deveria falar com\naquela mulher antes de sair...", body)
		return

	body.velocity.x = 0
	body.blocked = true
	await get_tree().create_timer(0.1).timeout
	body.blocked = false
	get_tree().change_scene_to_file("res://Scene/Serra Backup.tscn")

func _show_message(text: String, player: Node2D):
	# evita duplicar se já tiver uma mensagem aparecendo
	if player.has_node("ThoughtLabel"):
		return

	var label = Label.new()
	label.name = "ThoughtLabel"
	label.text = text
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.position = Vector2(-60, -70)  # ← ajusta altura conforme seu sprite
	label.add_theme_font_size_override("font_size", 8)
	if game_font:
		label.add_theme_font_override("font", game_font)

	player.add_child(label)
	await get_tree().create_timer(message_duration).timeout
	label.queue_free()

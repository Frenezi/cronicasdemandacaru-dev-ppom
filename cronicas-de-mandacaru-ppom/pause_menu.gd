extends CanvasLayer

@onready var continue_button = $menu_holder/continue_button
@onready var opcoes_button = $menu_holder/opcoes_button

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	
	continue_button.pressed.connect(_on_continuar)
	opcoes_button.pressed.connect(_on_opcoes)

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_Q:
		if visible:
			_on_continuar()
		else:
			_abrir()

func _abrir():
	show()
	get_tree().paused = true

func _on_continuar():
	hide()
	get_tree().paused = false

func _on_opcoes():
	get_tree().change_scene_to_file("res://Scene/menu_opcs.tscn")

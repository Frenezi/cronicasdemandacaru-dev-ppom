extends CanvasLayer

@onready var bg_overlay = $BG_overlay
@onready var menu_holder = $menu_holder
@onready var continue_button = $menu_holder/continue_button
@onready var opcs_button = $menu_holder/opcs_button

var menu_aberto: bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS  # ← também aqui
	menu_holder.visible = false
	bg_overlay.visible = false
	continue_button.pressed.connect(_on_continue_pressed)
	opcs_button.pressed.connect(_on_opcs_pressed)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Q:
			if menu_aberto:
				fechar_menu()
			else:
				abrir_menu()

func abrir_menu():
	menu_aberto = true
	menu_holder.visible = true
	bg_overlay.visible = true
	get_tree().paused = true

func fechar_menu():
	menu_aberto = false
	menu_holder.visible = false
	bg_overlay.visible = false
	get_tree().paused = false

func _on_continue_pressed():
	fechar_menu()

func _on_opcs_pressed():
	menu_holder.visible = false
	var opcs = load("res://Scene/opções_menu.tscn").instantiate()
	add_child(opcs)
	opcs.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var tamanho = get_viewport().get_visible_rect().size
	opcs.position = Vector2.ZERO
	opcs.size = tamanho

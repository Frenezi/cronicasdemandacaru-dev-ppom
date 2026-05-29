extends CanvasLayer

@export var screen_id: String = "variaveis"  # ← define no Inspector de cada um

@onready var papiro = $layer
@onready var anim = $AnimationPlayer

var was_paused: bool = false

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("reference_screen")
	add_to_group("ref_" + screen_id)  # ← grupo único ex: "ref_variaveis"
	papiro.visible = false

func _input(event):
	if not papiro.visible:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		_close()
	if event.is_action_pressed("cancel"):
		_close()

func open():
	was_paused = get_tree().paused
	papiro.visible = true
	anim.play("abrindo")
	get_tree().paused = true

func reopen():
	open()

func _close():
	papiro.visible = false
	if not was_paused:
		get_tree().paused = false

extends CanvasLayer

@onready var papiro = $layer
@onready var anim = $AnimationPlayer

var current_id: String = ""
var papiros = {
	"dica_1": preload("res://Sprites/papiros/dica_1.png"),
}

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group("reference_screen")
	papiro.visible = false

func _input(event):
	if not papiro.visible:
		return
	if event is InputEventKey and event.pressed and event.keycode == KEY_E:
		_close()
	if event.is_action_pressed("cancel"):
		_close()

func open(reference_id: String):
	current_id = reference_id
	var texture = papiros.get(reference_id, null)
	if texture == null:
		return
	papiro.texture = texture
	papiro.visible = true
	anim.play("abrindo")
	get_tree().paused = true

func reopen():
	if current_id != "":
		open(current_id)

func _close():
	papiro.visible = false
	if get_tree().get_first_node_in_group("puzzle_layer") == null:
		get_tree().paused = false

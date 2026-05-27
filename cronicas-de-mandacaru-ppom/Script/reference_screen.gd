extends CanvasLayer

@onready var papiro = $TextureRect
@onready var close_button = $TextureRect/TextureButton

var current_id: String = ""

var papiros = {
	"dica_1": preload("res://Sprites/papiros/dica_1.png"),
	#"dica_2": preload("res://Sprites/papiros/dica_2.png"),
}

func _ready():
	add_to_group("reference_screen")
	papiro.visible = false
	close_button.pressed.connect(_close)

func open(reference_id: String):
	current_id = reference_id
	var texture = papiros.get(reference_id, null)
	if texture == null:
		return
	papiro.texture = texture
	papiro.visible = true
	get_tree().paused = true

func reopen():
	if current_id != "":
		open(current_id)

func _close():
	papiro.visible = false
	get_tree().paused = false

func _process(_delta):
	if papiro.visible and Input.is_action_just_pressed("cancel"):
		_close()

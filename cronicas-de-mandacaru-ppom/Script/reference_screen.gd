extends CanvasLayer

# Grupo: "reference_screen"
# Process Mode: Always (para funcionar durante pausa)

@onready var panel = $Panel
@onready var title_label = $Panel/VBox/Title
@onready var content_label = $Panel/VBox/Content
@onready var close_button = $Panel/VBox/CloseButton

var current_id: String = ""

func _ready():
	add_to_group("reference_screen")
	panel.visible = false
	close_button.pressed.connect(_close)

func open(reference_id: String):
	current_id = reference_id
	var ref = ReferenceGlobal.references.get(reference_id, null)
	if ref == null:
		return
	title_label.text = ref["title"]
	content_label.text = ref["content"]
	panel.visible = true
	get_tree().paused = true  # pausa enquanto lê

func reopen():
	# Chamado pelo botão no puzzle
	if current_id != "":
		open(current_id)

func _close():
	panel.visible = false
	get_tree().paused = false

func _process(_delta):
	if panel.visible and Input.is_action_just_pressed("cancel"):
		_close()

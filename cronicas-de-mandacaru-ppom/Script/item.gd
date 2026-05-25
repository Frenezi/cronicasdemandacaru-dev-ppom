extends Sprite2D

@export var reference_id: String = "variaveis"  # chave no dicionário de referências
@export var item_name: String = "Caderno de Variáveis"

var player_nearby: bool = false
var collected: bool = false

@onready var label_e = $LabelE  # Label mostrando "[E] Pegar"
@export var item_flag: String = "notebook_1_paper"  

func _ready():
	label_e.visible = false

func _process(_delta):
	if collected:
		return
	print("nearby: ", player_nearby, " | collected: ", collected)  # ← temporário
	if player_nearby and Input.is_action_just_pressed("interact"):
		print("coletou!")
		_collect()

func _collect():
	collected = true
	label_e.visible = false
	ReferenceGlobal.collected_items[item_flag] = true  # ← marca como coletado
	var ref_screen = get_tree().get_first_node_in_group("reference_screen")
	if ref_screen:
		ref_screen.open(reference_id)
	self.visible = false

func _on_area_body_entered(body):
	print("entrou: ", body.name)
	if body.is_in_group("player"):
		player_nearby = true
		label_e.visible = true

func _on_area_body_exited(body):
	print("saiu: ", body.name)
	if body.is_in_group("player"):
		player_nearby = false
		label_e.visible = false

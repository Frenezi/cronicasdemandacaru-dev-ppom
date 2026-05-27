extends Sprite2D

@export var reference_id: String = "variaveis"  # chave no dicionário de referências
@export var item_name: String = "Caderno de Variáveis"

var player_nearby: bool = false
var collected: bool = false
var player_ref = null

@onready var label_e = $LabelE  # Label mostrando "[E] Pegar"
@export var item_flag: String = "notebook_1_paper"  

func _ready():
	label_e.visible = false

func _process(_delta):
	if collected:
		return
	if player_nearby and player_ref and player_ref.is_on_floor():
		label_e.visible = true
		if Input.is_action_just_pressed("interact"):
			_collect()
	elif player_nearby and player_ref and not player_ref.is_on_floor():
		label_e.visible = false  # ← esconde o E quando no ar


func _collect():
	collected = true
	label_e.visible = false
	ReferenceGlobal.collected_items[item_flag] = true  
	var ref_screen = get_tree().get_first_node_in_group("reference_screen")
	if ref_screen:
		ref_screen.open("dica_1")
	self.visible = false

func _on_area_body_entered(body):
	if body.is_in_group("player"):
		player_ref = body 
		player_nearby = true
		label_e.visible = true

func _on_area_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
		label_e.visible = false

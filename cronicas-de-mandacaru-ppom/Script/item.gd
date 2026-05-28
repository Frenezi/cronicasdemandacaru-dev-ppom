extends Sprite2D
@export var reference_id: String = "variaveis"
@export var item_name: String = "Caderno de Variáveis"
var collected: bool = false
@export var item_flag: String = "notebook_1_paper"  

func _ready():
	_start_float_tween()

func _on_area_body_entered(body):
	if body.is_in_group("player") and not collected:
		_collect()

func _collect():
	collected = true
	ReferenceGlobal.collected_items[item_flag] = true  
	var ref_screen = get_tree().get_first_node_in_group("reference_screen")
	if ref_screen:
		ref_screen.open("dica_1")
	self.visible = false

func _start_float_tween():
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(self, "position:y", position.y - 5, 1.0)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position:y", position.y + 5, 1.0)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
	var rot_tween = create_tween()
	rot_tween.set_loops()
	rot_tween.tween_property(self, "rotation_degrees", 360.0, 3.0)\
		.set_trans(Tween.TRANS_LINEAR)

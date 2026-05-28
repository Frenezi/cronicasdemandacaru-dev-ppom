extends HBoxContainer

@onready var coracoes = [$Coracao1, $Coracao2, $Coracao3, $Coracao4, $Coracao5]

var health: int = 0:
	set = _set_health

func _set_health(new_health):
	health = clamp(new_health, 0, 5)
	_update_coracoes()

func ini_health(_health):
	health = _health
	_update_coracoes()

func _update_coracoes():
	for i in range(coracoes.size()):
		var atlas = coracoes[i].texture.duplicate() as AtlasTexture
		if i < health:
			atlas.region = Rect2(2, 0, 16, 16)
		else:
			atlas.region = Rect2(34, 0, 16, 16)
		coracoes[i].texture = atlas

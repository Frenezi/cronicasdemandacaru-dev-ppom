extends CanvasLayer

@onready var slider_master = $Control/slider_master
@onready var slider_efeitos = $Control/slider_efeitos
@onready var bt_voltar = $Control/bt_sair

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	slider_master.min_value = -40
	slider_master.max_value = 0
	slider_master.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))
	slider_efeitos.min_value = -40
	slider_efeitos.max_value = 0
	slider_efeitos.value = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Ad. Efeito"))
	slider_master.value_changed.connect(_on_master_changed)
	slider_efeitos.value_changed.connect(_on_efeitos_changed)
	bt_voltar.pressed.connect(_on_voltar)

func _on_master_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), value)

func _on_efeitos_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ad. Efeito"), value)

func _on_voltar():
	get_tree().change_scene_to_file("res://Scene/menu.tscn")

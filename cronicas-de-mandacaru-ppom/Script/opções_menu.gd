extends Control

@onready var slider_musica = $VBoxContainer/HBoxContainer/HSlider
@onready var slider_efeitos = $VBoxContainer/HBoxContainer2/HSlider
@onready var check_mutar = $VBoxContainer/HBoxContainer4/CheckButton
@onready var botao_voltar = $VBoxContainer/HBoxContainer5/Button

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	# removeu o set_anchors_and_offsets_preset daqui
	slider_musica.value_changed.connect(_on_musica_changed)
	slider_efeitos.value_changed.connect(_on_efeitos_changed)
	check_mutar.toggled.connect(_on_mutar_toggled)
	botao_voltar.pressed.connect(_on_voltar)

func _on_musica_changed(valor):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(valor))

func _on_efeitos_changed(valor):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(valor))

func _on_mutar_toggled(ativado):
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), ativado)

func _on_voltar():
	print("pai: ", get_parent().name)
	for child in get_parent().get_children():
		print("filho: ", child.name)
	queue_free()

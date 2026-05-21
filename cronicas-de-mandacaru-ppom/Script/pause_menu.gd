extends CanvasLayer


@onready var continue_button: Button = $menu_holder/continue_button



func _ready():
	visible = false


func _process(delta):
	pass

func _unhandled_input(event):
	if event. is_action_pressed("ui_cancel"):
		visible = true
		get_tree().paused = true
		continue_button.grab_focus()

func _on_continue_button_pressed():
	get_tree().paused = false
	visible = false	


func _on_quit_button_pressed():
	get_tree().quit()
	
	
	

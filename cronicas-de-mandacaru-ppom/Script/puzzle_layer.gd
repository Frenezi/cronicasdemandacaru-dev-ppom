extends CanvasLayer

var correct_answer := ""
var callback_when_done = null
@onready var puzzle_layer: CanvasLayer = $"."
var fade_duration = 1

@onready var puzzle_screen = $ColorRect
@onready var question_label = $ColorRect/Panel/Pergunta
@onready var input = $ColorRect/Panel/Input
@onready var error_label = $ColorRect/Panel/Error
@onready var btn = $ColorRect/Panel/Confirm


func setup(question: String, answer: String, callback: Callable):
	correct_answer = answer.to_lower()
	callback_when_done = callback
	question_label.text = question
	error_label.visible = false
	input.text = ""
	input.grab_focus()
	fade_in()

func _ready():
		btn.connect("pressed", Callable(self, "_on_confirm"))	
		print(puzzle_layer)   # deve imprimir [Node2D] ou [Control]
		print(puzzle_screen.modulate)
func fade_in():
	var tw = create_tween()
	tw.tween_property(puzzle_screen, "modulate:a", 0.8, 0.7)

func fade_out():
	var tw = create_tween()
	tw.tween_property(puzzle_screen, "modulate:a", 0.0, 0.7)
	await tw.finished
	queue_free()

func _on_confirm():
	var txt = input.text.to_lower()

	if txt == correct_answer:
		# resposta certa
		callback_when_done.call()
		fade_out()
	else:
		# resposta errada
		error_label.text = "Resposta incorreta!"
		error_label.visible = true
		var tween = create_tween()
		tween.tween_property(error_label, "modulate:a", 0, fade_duration)
		

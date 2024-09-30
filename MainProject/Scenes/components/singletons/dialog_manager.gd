extends Node

@onready var text_box_scene = preload("res://MainProject/Scenes/typography/text_box.tscn")

var dialog_lines: Array[String] = []
var current_line_index = 0

var text_box: MarginContainer
var text_box_position: Vector2

var is_dialog_active = false
var can_advance_line = false

signal dialog_finished()

func start_dialog(position: Vector2, lines: Array[String]):
	if is_dialog_active:
		return
	
	dialog_lines = lines
	text_box_position = position
	_show_text_box()
	
	is_dialog_active = true

func stop_dialog():
	if not is_dialog_active:
		return
	
	dialog_lines = []
	text_box_position = Vector2()
	
	if not text_box == null:
		text_box.queue_free()

	current_line_index = 0
	can_advance_line = false
	is_dialog_active = false
	dialog_finished.emit()

func _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child(text_box)
	text_box.global_position = text_box_position
	text_box.display_text(dialog_lines[current_line_index])
	can_advance_line = false

func _on_text_box_finished_displaying():
	can_advance_line = true

func _unhandled_input(event):
	var is_interact_pressed = event.is_action_pressed("interact")
	# TODO: separate advance and skip dialog options
	var is_advance_diallog_pressed = event.is_action_pressed("advance_dialog")
	if (
		(is_advance_diallog_pressed or is_interact_pressed) &&
		is_dialog_active &&
		(can_advance_line or is_advance_diallog_pressed) # Allows to skip dialog
	):
		print("dialog skipped: ", (not can_advance_line and is_advance_diallog_pressed))
		text_box.queue_free()
		
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			dialog_finished.emit()
			return
		
		_show_text_box()

extends Control
class_name SettingsMenu

signal back_button_pressed()

func _ready() -> void:
	if OS.get_name() == "Web":
		$MarginContainer/TabsContainer.set_current_tab(1)
		$MarginContainer/TabsContainer.set_tab_hidden(0, true)

func _unhandled_key_input(event):
	if Input.is_action_just_pressed('reset'):
		back_button_pressed.emit()

func _on_button_pressed() -> void:
	back_button_pressed.emit()

extends Control

@export_subgroup("Settings")
@export var load_scene: PackedScene
@export var in_time: float = 0 #0.25
@export var fade_in_time: float = 0.75
@export var pause_time: float = 0.75
@export var fade_out_time: float = 0.75
@export var out_time: float = 0.25

# TODO: reuse same path in Game scene
const SAVE_PATH = "user://example_save_data.sav"
var has_existing_save: bool = false
var settings: SettingsMenu

func _ready() -> void:
	focus_on_first_menu_item()
	
	if OS.get_name() == "Web":
		$VBoxContainer/ExitButton.hide()
		$VBoxContainer2/ToggleFullscreen.show()

	await fade_in()

func focus_on_first_menu_item() -> void:
	has_existing_save = FileAccess.file_exists(SAVE_PATH)

	if has_existing_save:
		$VBoxContainer/ContinueButton.grab_focus()
	else:
		$VBoxContainer/ContinueButton.hide()
		$VBoxContainer/NewGameButton.grab_focus()

func _on_continue_button_pressed() -> void:
	get_tree().change_scene_to_packed(load_scene)

func _on_new_game_button_pressed() -> void:
	DirAccess.remove_absolute(SAVE_PATH)
	get_tree().change_scene_to_packed(load_scene)

func _on_settings_button_pressed() -> void:
	settings = load("res://MainProject/Scenes/menu/settings/settings.tscn").instantiate()
	settings.back_button_pressed.connect(_on_exit_settings_pressed, CONNECT_DEFERRED)
	get_tree().current_scene.add_child(settings)

func _on_exit_settings_pressed() -> void:
	if settings != null:
		settings.queue_free()
		settings = null

	focus_on_first_menu_item()

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func fade_in() -> void:
	self.modulate.a = 0.0

	var tween = self.create_tween()
	tween.tween_interval(in_time)
	tween.tween_property(self, "modulate:a", 1.0, fade_in_time)
	await tween.finished

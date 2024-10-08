extends Control

var settings: SettingsMenu

func _ready() -> void:
	if OS.get_name() == 'Web':
		$Buttons/Exit.hide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and not Game.get_singleton().is_cutscene_running:
		toggle_pause_menu()

func _on_resume_button_pressed() -> void:
	toggle_pause_menu()

func toggle_pause_menu():
	var is_paused = get_tree().paused

	if is_paused:
		# TODO: might be useful
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		self.hide()
		get_tree().paused = false
	else:
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		self.show()
		get_tree().paused = true

func _on_visibility_changed() -> void:
	if self.visible:
		$Buttons/Resume.grab_focus()

func _on_settings_pressed() -> void:
	settings = load("res://MainProject/Scenes/menu/settings/settings.tscn").instantiate()
	settings.back_button_pressed.connect(_on_exit_settings_pressed, CONNECT_DEFERRED)
	add_child(settings)

func _on_exit_settings_pressed() -> void:
	if settings != null:
		settings.queue_free()
		settings = null

	$Buttons/Resume.grab_focus()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_restart_level_pressed() -> void:
	toggle_pause_menu()
	var player: MainCharacter = Game.get_singleton().player
	player.instant_kill()

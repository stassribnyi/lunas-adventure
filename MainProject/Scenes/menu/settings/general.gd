extends TabBar

func _ready() -> void:
	var window_mode = Persistence.config.get_value("Video", "fullscreen")
	var is_borderless = Persistence.config.get_value("Video", "borderless")
	var vsync_index = Persistence.config.get_value("Video", "vsync")
	
	$HBoxContainer/Controls/FullscreenCheckbox.button_pressed  = true if window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN else false
	$HBoxContainer/Controls/BorderlessCheckbox.button_pressed  = is_borderless
	$HBoxContainer/Controls/VsyncOptions.selected = vsync_index

func _on_fullscreen_checkbox_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Persistence.config.set_value("Video", "fullscreen", DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Persistence.config.set_value("Video", "fullscreen", DisplayServer.WINDOW_MODE_WINDOWED)

	Persistence.save_data()

func _on_borderless_checkbox_toggled(toggled_on: bool) -> void:
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, toggled_on)
	Persistence.config.set_value("Video", "borderless", toggled_on)
	Persistence.save_data()

func _on_vsync_options_item_selected(index: int) -> void:
	DisplayServer.window_set_vsync_mode(index)
	Persistence.config.set_value("Video", "vsync", index)
	Persistence.save_data()

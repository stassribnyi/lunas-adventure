extends TabBar

enum AudioBus {
	MASTER = 0,
	MUSIC = 1,
	SFX = 2
}

func _ready() -> void:
	$HBoxContainer/Controls/Master.value = Persistence.config.get_value("Audio", str(AudioBus.MASTER))
	$HBoxContainer/Controls/Music.value = Persistence.config.get_value("Audio", str(AudioBus.MUSIC))
	$HBoxContainer/Controls/SFX.value = Persistence.config.get_value("Audio", str(AudioBus.SFX))
	
	var audio_values = [$HBoxContainer/Controls/Master, $HBoxContainer/Controls/Music, $HBoxContainer/Controls/SFX]
	
	for i in range(audio_values.size()):
		AudioServer.set_bus_volume_db(i, linear_to_db(audio_values[i].value))

func _on_master_value_changed(value: float) -> void:
	set_volume(AudioBus.MASTER, value)

func _on_music_value_changed(value: float) -> void:
	set_volume(AudioBus.MUSIC, value)

func _on_sfx_value_changed(value: float) -> void:
	set_volume(AudioBus.SFX, value)

func set_volume(index: AudioBus, value: float) -> void:
	AudioServer.set_bus_volume_db(index, linear_to_db(value))
	Persistence.config.set_value("Audio", str(index), value)
	Persistence.save_data()

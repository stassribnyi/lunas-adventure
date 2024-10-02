extends Node2D
class_name SFXComponent

@export_subgroup("Settings")
@export var sfx_footsteps: AudioStream
@export var sfx_jump: AudioStream
@export var sfx_hurt: AudioStream
@export var sfx_death: AudioStream
@export var sfx_teleport: AudioStream

@export_subgroup("Nodes")
@export var sfx_player: AudioStreamPlayer2D

func play_footsteps() -> void:
	play(sfx_footsteps)

func play_jump() -> void:
	play(sfx_jump)

func play_hurt() -> void:
	play(sfx_hurt)

func play_death() -> void:
	play(sfx_death)

func play_teleport() -> void:
	play(sfx_teleport)

func play(sfx: AudioStream) -> void:
	load_sfx(sfx)
	sfx_player.play()

func load_sfx(sfx_to_load: AudioStream) -> void:
	if sfx_player.stream != sfx_to_load:
		sfx_player.stop()
		sfx_player.stream = sfx_to_load

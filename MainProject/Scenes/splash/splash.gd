extends Control

@export_subgroup("Settings")
@export var load_scene: PackedScene
@export var in_time: float = 0.25
@export var fade_in_time: float = 0.75
@export var pause_time: float = 0.75
@export var fade_out_time: float = 0.75
@export var out_time: float = 0 #0.25
@export var splash_screen: AnimatedSprite2D

func _ready() -> void:
	fade()

func fade() -> void:
	#self.modulate.a = 0.0
	
	var tween = self.create_tween()
	tween.tween_interval(in_time)
	tween.tween_property(self, "modulate:a", 1.0, fade_in_time)
	tween.tween_interval(pause_time)
	tween.tween_property(self, "modulate:a", 0.0, fade_out_time)
	tween.tween_interval(out_time)
	await tween.finished
	
	get_tree().change_scene_to_packed(load_scene)
	

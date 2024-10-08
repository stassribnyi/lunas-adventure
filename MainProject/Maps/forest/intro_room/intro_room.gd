extends Node2D

@export_subgroup("Nodes")
@export var animation_player: AnimationPlayer

var player: MainCharacter
var is_walking = false
var next_position_direction: Vector2

var trackIndex: int = 0
var track: Array[StringName] = ["intro_start", "move_to_the_slope", "move_to_the_portal"]
var track_delay: Array[float] = [0.5, 1, 0.2]
var track_duration: Array[float] = [2, 4, 1]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Game.get_singleton().is_cutscene_running = true
	Game.get_singleton().toggle_ambient(false)
	player = Game.get_singleton().player
	player.event = true
	player.position = $PlayerSpawnPosition.position
	animation_player.play("slideshow")

func _process(delta: float) -> void:
	if is_walking:
		player.animation_player.play("Walk")
	else:
		player.animation_player.play("Idle")

func move_player_to(destination: Vector2) -> void:
	player.event = true if trackIndex < track.size() - 1 else false
	is_walking = true

	var tween = get_tree().create_tween()
	tween.tween_property(player, "position", destination, track_duration[trackIndex])
	tween.tween_callback(on_stop_walking)

func on_stop_walking() -> void:
	trackIndex += 1
	is_walking = false

	if trackIndex < track.size():
		await get_tree().create_timer(track_delay[trackIndex]).timeout
		animation_player.play(track[trackIndex])

func on_slideshow_end() -> void:
	Game.get_singleton().toggle_ambient(true)
	animation_player.play(track[trackIndex])

func _notification(what):
	if (what == NOTIFICATION_PREDELETE):
		player.event = false
		Game.get_singleton().is_cutscene_running = false

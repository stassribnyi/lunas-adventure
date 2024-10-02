# A portal object that transports to another world layer.
extends Area2D
# The target map after entering the portal.
@export var target_map: String

func _on_body_entered(body: Node2D) -> void:
	# If player entered and isn't doing an event (event in this case is entering the portal).
	if body.is_in_group(&"player") and not body.event:
		var player: MainCharacter = body
		player.event = true
		player.velocity = Vector2()
		# Tween the player position into the portal.
		var tween := create_tween()
		tween.tween_property(player, ^"position", position, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
		tween.tween_callback(func(): on_tween_finished(player))
		await tween.finished

func on_tween_finished(player: MainCharacter) -> void:
	player.sfx_component.play_teleport()
	# After tween finished, change the map.
	Game.get_singleton().load_room(target_map)
	# A trick to reset player's event variable when it's safe to do so (i.e. after some frames).
	get_tree().create_timer(0.2).timeout.connect(player.set.bind(&"event", false))
	# Delta vector feature again.
	Game.get_singleton().reset_map_starting_coords()

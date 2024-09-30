class_name AnimationComponent
extends Node

@export_subgroup("Nodes")
@export var sprite: Sprite2D
@export var animation_player: AnimationPlayer

func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0:
		return

	sprite.scale.x = abs(sprite.scale.x) * (1 if move_direction > 0 else -1)

func handle_move_animation(move_direction: float) -> void:
	handle_horizontal_flip(move_direction)
	
	if move_direction != 0:
		animation_player.play("Walk")
	else:
		animation_player.play("Idle")

func handle_jump_animation(is_jumping: bool, is_falling: bool) -> void:
	if is_jumping:
		animation_player.play("Jump")
	elif is_falling:
		animation_player.play("Fall")

func handle_attack_animation() -> void:
	animation_player.play("FastShoot")

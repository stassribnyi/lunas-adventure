class_name MovementComponent
extends Node

@export_subgroup("Settings")
@export var speed: float = 200
@export var ground_accel_speed: float = 20.0
@export var ground_decel_speed: float = 32.0
@export var air_accel_speed: float = 24.0
@export var air_decel_speed: float = 8.0
@export var dash_speed: float = 2400
@export var dash_length: float = 0.1

@export_subgroup("Nodes")
@export var dash_timer: Timer
@export var dash_cooldown_timer: Timer

func start_dash(duration: float) -> void:
	dash_timer.wait_time = duration
	dash_timer.start()
	dash_cooldown_timer.start()

func is_dashing() -> bool:
	return !dash_timer.is_stopped()

func can_dash(body: MainCharacter) -> bool:
	return &"dash" in body.abilities and dash_cooldown_timer.is_stopped()

func handle_horizontal_movement(body: CharacterBody2D, direction: float) -> void:
	if direction != 0 and Input.is_action_just_pressed("dash") and can_dash(body):
		start_dash(dash_length)
	
	var velocity_change_speed: float = 0.0
	if body.is_on_floor():
		velocity_change_speed = ground_accel_speed if direction != 0 else ground_decel_speed
	else:
		velocity_change_speed = air_accel_speed if direction != 0 else air_decel_speed

	var new_speed = dash_speed if is_dashing() else speed
	var new_velocity_change =  dash_speed / speed * velocity_change_speed if is_dashing() else velocity_change_speed

	body.velocity.x = move_toward(body.velocity.x, direction * new_speed, new_velocity_change)

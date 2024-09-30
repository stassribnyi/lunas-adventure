class_name GunComponent
extends Node2D

@export_subgroup("Nodes")
@export var marker: Marker2D
@export var shooting_speed_timer: Timer

@export_subgroup("Settings")
@export var shooting_speed: float = 1.0

const BULLET = preload("res://MainProject/Scenes/bullet/bullet.tscn")

var can_shoot = true
var bullet_direction = Vector2(1, 0)

func _ready() -> void:
	shooting_speed_timer.wait_time = 1.0 / shooting_speed

func shoot():
	if can_shoot:
		can_shoot = false
		shooting_speed_timer.start()

		var bullet_node = BULLET.instantiate()
		bullet_node.set_direction(bullet_direction)
		get_tree().root.add_child(bullet_node)
		bullet_node.global_position = marker.global_position

func _on_shooting_speed_timer_timeout() -> void:
	can_shoot = true

func is_shooing() -> bool:
	return !shooting_speed_timer.is_stopped()

func setup_direction(direction):
	bullet_direction = direction

	if direction.x > 0:
		scale.x = 1
		rotation_degrees = 1
	elif direction.x < 0:
		scale.x = -1
		rotation_degrees = 0
	elif direction.y < 0:
		scale.x = 1
		rotation_degrees = -90
	elif direction.y > 0:
		scale.x = 1
		rotation_degrees = 90

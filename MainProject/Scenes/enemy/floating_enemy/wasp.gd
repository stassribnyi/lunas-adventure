extends Node2D

@export_subgroup("Settings")
@export var horizontal_motion: bool = true
@export var hp: float = 100
@export var patrol_distance: float = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FloatingEnemy.horizontal_motion = horizontal_motion
	$FloatingEnemy.hp = hp
	$FloatingEnemy.patrol_distance = patrol_distance

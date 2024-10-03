extends Node2D

@export_subgroup("Settings")
@export var hp: float = 100
@export var patrol_distance: float = 200
@export var time_to_change: float = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$FloatingEnemy.horizontal_motion = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$FloatingEnemy.hp = hp
	$FloatingEnemy.patrol_distance = patrol_distance
	$FloatingEnemy.time_to_change = time_to_change

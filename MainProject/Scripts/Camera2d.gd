extends Camera2D

@export_category("Screen Shake")
@export var randomStrength: float = 10.0
@export var shakeFade: float = 10.0


@export_category("Follow Player")
@export var player: CharacterBody2D

@export_category("Camera Smothing")
@export var smothingEnabled: bool
@export_range(1, 10) var smothingDistance: int = 8

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var weight : float

func apply_shake():
	shake_strength = randomStrength

func _process(delta):
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shakeFade * delta)
		offset = randomOffset()

func _ready() -> void:
	weight = float(11 - smothingDistance) / 100
	
# NOT WORKING AS EXPECTED AS OF NOW
func _physics_process(delta: float) -> void:
	if player != null:
		var camera_position: Vector2

		if smothingEnabled:
			camera_position = lerp(global_position, player.global_position, weight)
		else:
			camera_position = player.global_position

		global_position = camera_position.floor()


func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

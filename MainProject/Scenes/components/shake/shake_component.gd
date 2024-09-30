class_name ShakeComponent
extends Node

@export_category("Screen Shake")
@export var randomStrength: float = 10.0
@export var shakeFade: float = 10.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0
var weight : float

func apply_shake():
	shake_strength = randomStrength

func set_body_on_shake(body: Node2D, delta: float):
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shakeFade * delta)
		body.offset = randomOffset()

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength, shake_strength), rng.randf_range(-shake_strength, shake_strength))

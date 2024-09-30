extends AnimatedSprite2D

@export_subgroup("Settings")
@export var enabled: bool = true

func _process(delta: float) -> void:
	if enabled:
		play("default")
	else:
		play("broken")

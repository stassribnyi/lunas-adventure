extends Area2D

@export_subgroup("Settings")
@export var lives: int = 1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not body.is_dying:
		print(self.name)
		body.kill(lives)

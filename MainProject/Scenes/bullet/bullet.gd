extends Area2D

@export_subgroup("Settings")
@export var speed: float = 200.0
@export var damage: float = 15.0

var direction: Vector2

func set_direction(bullet_direction: Vector2):
	direction = bullet_direction
	rotation_degrees = rad_to_deg((global_position.angle_to_point((global_position + direction))))

func _ready() -> void:
	await get_tree().create_timer(3).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	print(body.get_groups())
	if body.is_in_group("enemies"):

		body.set_damage(damage, direction)
		queue_free()
	elif body.is_in_group("environment"):
		queue_free()

extends CharacterBody2D

@export_subgroup("Nodes")
@export var floor_raycast: RayCast2D
@export var sfx_component: SFXComponent

@export_subgroup("Settings")
@export var gravity: float = 1000
@export var speed: float = 100
@export var hp: float = 100

var current_velocity: Vector2 = Vector2.ZERO

func _ready():
	current_velocity.x = speed

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		current_velocity.y += gravity * delta
	else:
		current_velocity.y = 0

	if is_on_wall() or (is_on_floor() and not floor_raycast.is_colliding()):
		current_velocity.x *= -1.0 # Reverse velocity
		floor_raycast.position.x *= -1.0 # Reverse raycast position
		flip_horizontal()

	velocity = current_velocity
	move_and_slide()

func flip_horizontal() -> void:
	$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h

func set_damage(damage: float, direction: Vector2) -> void:
	hp -= damage
	sfx_component.play_hurt()

	if hp <= 0:
		Game.get_singleton().kills += 1
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property($AnimatedSprite2D, "modulate:v", 1, 0.25).from(15)
		tween.tween_property($AnimatedSprite2D, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_ELASTIC)
		tween.tween_callback(queue_free)
	else:
		apply_knokback(direction, damage)

# TODO: move into separate component
func apply_knokback(direction: Vector2, strength: float):
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:x", position.x + abs(strength) * direction.x, 0.25).from(position.x).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($AnimatedSprite2D, "modulate:v", 1, 0.25).from(15)

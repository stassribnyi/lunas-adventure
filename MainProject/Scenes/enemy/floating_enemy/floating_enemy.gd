extends CharacterBody2D

# Variables to control movement
var base_speed = 64
var direction = 1
var start_position

@export_subgroup("Nodes")
@export var sprite: AnimatedSprite2D

@export_subgroup("Settings")
@export var horizontal_motion: bool = true
@export var hp: float = 100
@export var patrol_distance: float = 200

# Timer to control direction change
@export var time_to_change: float = 2.0 # Time in seconds to change direction

var timer = 0.0

func _ready():
	# Store the starting position of the bird
	start_position = global_position

func _process(delta):
	# Move the bird left and right
	patrol(delta)

func patrol(delta):
	# Increment the timer
	timer += delta
	
	# Change direction if timer exceeds the time to change direction
	if timer >= time_to_change:
		direction *= -1 # Reverse direction
		timer = 0.0 # Reset timer
		flip_horizontal()

	# Calculate movement direction and move the bird
	if horizontal_motion:
		velocity = Vector2(direction * base_speed, 0)
	else:
		velocity = Vector2(0, direction * base_speed)
	move_and_slide()

	# Limit the movement range based on patrol_distance
	if abs(global_position.x - start_position.x) > patrol_distance:
		# Snap back to the patrol distance limit and reverse direction
		global_position.x = start_position.x + sign(direction) * patrol_distance
		direction *= -1  # Reverse direction immediately when hitting the limit
		timer = 0.0      # Reset timer


func flip_horizontal() -> void:
	sprite.flip_h = not sprite.flip_h

func set_damage(damage: float, dir: Vector2) -> void:
	hp -= damage

	if hp <= 0:
		Game.get_singleton().kills += 1
		var tween = get_tree().create_tween()
		tween.set_parallel(true)
		tween.tween_property(sprite, "modulate:v", 1, 0.25).from(15)
		tween.tween_property(sprite, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_ELASTIC)
		tween.tween_callback(queue_free)
	else:
		apply_knokback(dir, damage)

# TODO: move into separate component
func apply_knokback(dir: Vector2, strength: float):
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:x", position.x + strength * dir.x, 0.25).from(position.x).set_trans(Tween.TRANS_QUAD)
	tween.tween_property($AnimatedSprite2D, "modulate:v", 1, 0.25).from(15)

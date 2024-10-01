# This script is based on the default CharacterBody2D template. Not much interesting happening here.
extends CharacterBody2D

const DEFAULT_LIVES_AMOUNT: int = 3

@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component: MovementComponent
@export var animation_component: AnimationComponent
@export var jump_component: AdvancedJumpComponent
@export var gun_component: GunComponent
@export var sfx_component: SFXComponent

@export_subgroup("Settings")
@export var lives: int = DEFAULT_LIVES_AMOUNT

@onready var player_sprite: Sprite2D = $PlayerSprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var camera: Camera2D = $Camera2D
@onready var dash: GPUParticles2D = $DashParticles

signal hp_changed(hp: int)

var reset_position: Vector2

# Indicates that the player has an event happening and can't be controlled.
var event: bool

var is_shooting: bool = false
var is_dying: bool = false
var is_ready: bool = false
var variant: int = 0

var abilities: Array[StringName]

func _ready() -> void:
	jump_component.jumped.connect(_on_sfx_play_jump, CONNECT_DEFERRED)

func _physics_process(delta: float) -> void:
	if event and not is_ready:
		return
	
	if "double_jump" in abilities:
		jump_component.max_jump_count = 2

	if not is_shooting and not is_dying:
		gravity_component.handle_gravity(self, delta)
		movement_component.handle_horizontal_movement(self, input_component.input_horizontal)
		animation_component.handle_move_animation(input_component.input_horizontal)

		jump_component.handle_jump(self, input_component.get_jump_input(), input_component.get_jump_input_released())
		animation_component.handle_jump_animation(jump_component.is_going_up, gravity_component.is_falling)
	else:
		self.velocity.y = 0
		self.velocity.x = 0

	if Input.is_action_just_pressed("attack") and not (gravity_component.is_falling or jump_component.is_going_up):
		is_shooting = true
		animation_component.handle_attack_animation()

	# TODO: replace with power up system
	if Input.is_action_just_released("ui_text_delete"):
		if variant + 1 in range(1, 4):
			variant += 1
			evolve(variant)
		else:
			variant = 1

	var direction = Vector2.ZERO
	direction.x = input_component.input_horizontal
	dash.scale.x = input_component.input_horizontal
	
	#if direction != Vector2.ZERO:
		#dash.emitting = !movement_component.can_dash()

	dash.emitting = movement_component.is_dashing()

	if direction != Vector2.ZERO:
		gun_component.setup_direction(direction)

	move_and_slide()

func _shot() -> void:
	gun_component.shoot()
	is_shooting = false

func instant_kill() -> void:
	kill(lives)

func kill(damage: int):
	if lives > damage:
		sfx_component.play_hurt()
		apply_knokback(Vector2.ZERO, damage)
		change_hp(lives - damage)
		return

	sfx_component.play_death()
	change_hp(0)
	is_dying = true

	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position", position + Vector2(0, -20), 0.7)
	tween.tween_callback(play_death_animation)

func change_hp(new_hp: int) -> void:
	lives = new_hp
	hp_changed.emit(lives)

func _reset():
	# Player dies, reset the position to the entrance.
	change_hp(DEFAULT_LIVES_AMOUNT)
	print("Player:_reset() -> actual reset position: {0}, current position: {1}".format([reset_position, position]))
	position = reset_position
	Game.get_singleton().load_room(MetSys.get_current_room_name())

func _on_death_animation_end() -> void:
	_reset()

func play_death_animation():
	animation_player.play("Death")

func on_enter(re_position: Vector2 = position):
	# Position for kill system. Assigned when entering new room (see Game.gd).
	print("Player:on_enter() -> reset position: {0}, current position: {1}, param reset position: {2}".format([reset_position, position, re_position]))
	reset_position = re_position
	animation_player.play("Revive")

func _on_revive_animation_end() -> void:
	is_dying = false
	is_ready = true

# TODO: move into separate component
func apply_knokback(direction: Vector2, strength: float):
	var tween = get_tree().create_tween()
	#tween.set_parallel(true)
	#tween.tween_property(self, "position:y", position.y + strength * direction.y, 0.25).from(position.y).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(player_sprite, "modulate", Color.RED, 0.1)
	#tween.set_parallel(false)
	tween.tween_property(player_sprite, "modulate", Color.WHITE, 0.1)

func evolve(v: int) -> void:
	if v in range(1, 4):
		player_sprite.texture = ResourceLoader.load("res://MainProject/Sprites/luna/luna_{0}.png".format([v]))
	else:
		print("Evolve variant: ", v, ", doesn't exist")

func _on_sfx_play_jump() -> void:
	sfx_component.play_jump()

func _on_play_footsteps() -> void:
	sfx_component.play_footsteps()

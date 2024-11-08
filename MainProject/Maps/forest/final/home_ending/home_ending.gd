extends Node2D

@export_subgroup("Settings")
@export var load_scene: PackedScene

const section_time := 2.0
const line_time := 0.3
const base_speed := 100
const speed_up_multiplier := 10.0
const title_color := "#ffdf7e"

# var scroll_speed := base_speed
var speed_up := false

@onready var credits_container := $CreditsContainer
@onready var line := $CreditsContainer/CreditsLine
@onready var blur := $CreditsContainer/Blur
@onready var animation_player := $AnimationPlayer

var started := false
var finished := false
var is_credits_enabled := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
	[
		"A game by Game Busters"
	],[
		"Programming",
		"Stas Sribnyi",
	],[
		"Level Design",
		"Stas Sribnyi",
		"Roman Serebrianskyi",
	],[
		"Art",
		"Digital Illustration",
		"Olga Serebrianska",
		"",
		"Characters",
		"Roman Serebrianskyi",
	],[
		"Music",
		"Roman Serebrianskyi",
	],[
		"Sound Effects",
		"Stas Sribnyi",
	],[
		"Testers",
		"Hlib Zinchenko",
		"Glib “Migraine” Serebrianskyi",
	],[
		"Special thanks",
		"Our friends",
		"Kseniia Dudnyk",
		"@benbishopnz for credit scene",
	],[
		"Tools used",
		"Developed with Godot Engine",
		"https://godotengine.org/license",
		"",
		"Art created with GIMP and Procreate",
		"https://www.gimp.org/",
		"https://procreate.com/",
		"",
		"Audio Effects",
		"Audacity",
		"https://www.audacityteam.org/"
	]
]

func _ready() -> void:
	Game.get_singleton().is_cutscene_running = true
	Game.get_singleton().toggle_ambient(false)
	animation_player.play("start_ending")

func _process(delta):
	if not is_credits_enabled:
		return
	
	var scroll_speed = base_speed * delta
	
	if section_next:
		section_timer += delta * speed_up_multiplier if speed_up else delta
		if section_timer >= section_time:
			section_timer -= section_time
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta * speed_up_multiplier if speed_up else delta
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	if lines.size() > 0:
		for l in lines:
			l.position.y -= scroll_speed
			if l.position.y < -l.get_line_height():
				lines.erase(l)
				l.queue_free()
	elif started:
		finish()


func finish():
	if not finished:
		finished = true
		Game.get_singleton().is_cutscene_running = false
		Game.get_singleton().toggle_ambient(true)
		# This is called when the credits finish and returns to the main menu
		get_tree().change_scene_to_packed(load_scene)


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	if curr_line == 0:
		new_line.set("theme_override_colors/font_color", title_color)
	$CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finish()
	if event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
	if event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false

func set_blur(amount: float) -> void:
	blur.material.set_shader_parameter("amount", amount)

func start_credits():
	is_credits_enabled = true

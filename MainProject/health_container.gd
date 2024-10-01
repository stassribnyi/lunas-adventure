extends HBoxContainer

@onready var hp_1: AnimatedSprite2D = $TextureRect/HP_1
@onready var hp_2: AnimatedSprite2D = $TextureRect2/HP_2
@onready var hp_3: AnimatedSprite2D = $TextureRect3/HP_3

@onready var hearts = [hp_1, hp_2, hp_3]

# TODO: this is so bad, that I need to put it into frame on my wall
func _on_player_hp_changed(hp: int) -> void:
	for heart in hearts:
		heart.enabled = false

	for index in range(0, hp):
		if hp == 3:
			flash_heart(hearts[index])
			await get_tree().create_timer(0.15).timeout
		hearts[index].enabled = true

	for heart in hearts:
		if not heart.enabled:
			flash_heart(heart)
			return

func flash_heart(heart: AnimatedSprite2D) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(heart, "modulate:v", 1, 0.25).from(15)
	

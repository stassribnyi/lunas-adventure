extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $AnimatedSprite2D

const dialog_lines: Array[String] = [
	"Hey, little one!",
	"Are you lost?",
	"Oh... I see",
	"I can help if you are not afraid of a little challenge",
	"You see, a litle bee have stollen my ring...",
	"If you can bring it back, I'll share some magic with you...",
	"So, you can move through this dangerous place.",
]

const ring_found_dialog: Array[String] = [
	"Excellent! You found it. Now, let's see... Ah, yes. Here. Take this.",
	"Take this small, glowing amulet.",
	"This will grant you the ability to double jump. It's a handy tool for navigating this dangerous land. Use it wisely."
]

const ring_found_second_dialog: Array[String] = [
	"Thank you for returning my ring, little one!",
]

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.cancel_interaction = Callable(self, "_on_cancel_interaction")

func _on_interact():
	var player = Game.get_singleton().player
	var has_doublejump = true if &"double_jump" in player.abilities else false

	var dialog = dialog_lines
	if &"ring_1" in player.inventory and not has_doublejump:
		dialog = ring_found_dialog
	elif has_doublejump:
		dialog = ring_found_second_dialog

	DialogManager.start_dialog(global_position, dialog)
	sprite.flip_h = true if interaction_area.get_overlapping_bodies()[0].global_position.x < global_position.x else false
	await DialogManager.dialog_finished

	if &"ring_1" in player.inventory and not has_doublejump:
		player.abilities.append(&"double_jump")

	if player.has_something:
		player.heal(3)

func _on_cancel_interaction():
	DialogManager.stop_dialog()

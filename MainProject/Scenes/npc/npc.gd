extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $AnimatedSprite2D

const dialog_lines: Array[String] = [
	"Hello, young one.",
	"Lost? Well, perhaps this is fate.",
	"A small, golden ring has been misplaced.",
	"If you can find it, I'll reveal a secret that will aid you in your journey through this perilous place."
]

#const ring_found_dialog: Array[String] = [
	#"Excellent! You found it. Now, let's see... Ah, yes. Here. Take this.",
	#"Take this small, glowing amulet.",
	#"This will grant you the ability to double jump. It's a handy tool for navigating this dangerous land. Use it wisely."
#]

const ring_found_dialog: Array[String] = [
	"You have found the Queen's treasure, a gift she bestowed upon me ages past. Now, it is yours to claim.",
	"The blessing of the butterflies is yours.",
	"With this power, you can dash with incredible speed and agility.",
	"Use \"Shift\" to activate this ability.",
	"Remember, though, to wield this power with respect and always cherish the beauty of the butterflies.",
]

const ring_found_second_dialog: Array[String] = [
	"Remember, you can activate dash ability by pressing \"Shift\".",
]

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.cancel_interaction = Callable(self, "_on_cancel_interaction")

func _on_interact():
	var player = Game.get_singleton().player
	var has_doublejump = true if &"dash" in player.abilities else false

	var dialog = dialog_lines
	if &"ring_1" in player.inventory and not has_doublejump:
		dialog = ring_found_dialog
	elif has_doublejump:
		dialog = ring_found_second_dialog

	DialogManager.start_dialog(global_position, dialog)
	sprite.flip_h = true if interaction_area.get_overlapping_bodies()[0].global_position.x < global_position.x else false
	await DialogManager.dialog_finished

	if &"ring_1" in player.inventory and not has_doublejump:
		player.abilities.append(&"dash")

	if player.has_something:
		player.heal(3)

func _on_cancel_interaction():
	DialogManager.stop_dialog()

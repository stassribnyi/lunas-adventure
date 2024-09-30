extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $AnimatedSprite2D

const dialog_lines: Array[String] = [
	"Hey, you seem pretty strong!",
	"Wanna spar?",
	"Wait...",
	"I shouldn't waste my energy before an important battle...",
	"Well, I'll see you at the buffet!",
]


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.cancel_interaction = Callable(self, "_on_cancel_interaction")

func _on_interact():
	DialogManager.start_dialog(global_position, dialog_lines)
	sprite.flip_h = true if interaction_area.get_overlapping_bodies()[0].global_position.x < global_position.x else false
	await DialogManager.dialog_finished

func _on_cancel_interaction():
	DialogManager.stop_dialog()

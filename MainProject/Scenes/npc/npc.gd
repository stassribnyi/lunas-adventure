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


func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.cancel_interaction = Callable(self, "_on_cancel_interaction")

func _on_interact():
	DialogManager.start_dialog(global_position, dialog_lines)
	sprite.flip_h = true if interaction_area.get_overlapping_bodies()[0].global_position.x < global_position.x else false
	await DialogManager.dialog_finished

func _on_cancel_interaction():
	DialogManager.stop_dialog()

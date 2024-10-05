extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea

var dialog_lines: Array[String] = ["If you wish to follow the path of violence, be prepared for consequences!!!"]
var dialog_lines_option_two: Array[String] = ["Using it only brings pain and distruction, you still have choice..."]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.cancel_interaction = Callable(self, "_on_cancel_interaction")

func _on_interact():
	var player = Game.get_singleton().player
	DialogManager.start_dialog(global_position, dialog_lines if "mana_shoot" not in player.abilities else dialog_lines_option_two)
	await DialogManager.dialog_finished

func _on_cancel_interaction():
	DialogManager.stop_dialog()

extends Node2D

@export_subgroup("Settings")
@export_enum("Witch_1", "Witch_2", "Witch_3", "Queen") var type
@export var quest_item_name: String
@export var ability_upgrade_name: String

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $AnimatedSprite2D

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.cancel_interaction = Callable(self, "_on_cancel_interaction")
	
	match type:
		0: sprite.play("Witch_1")
		1: sprite.play("Witch_2")
		2: sprite.play("Witch_3")
		3: sprite.play("Queen")

func _on_interact():
	var player = Game.get_singleton().player
	var dialog_lines: Array[String] = ["Sorry, I can't help you a this moment..."]

	match type:
		0:
			dialog_lines = get_witch_1_dialog(player)
		1:
			dialog_lines = get_witch_2_dialog(player)
		_:
			pass
		

	DialogManager.start_dialog(global_position, dialog_lines)
	sprite.flip_h = true if interaction_area.get_overlapping_bodies()[0].global_position.x < global_position.x else false
	await DialogManager.dialog_finished

	upgrade_player_ability(player)

	if player.has_something:
		player.heal(3)

func get_witch_1_dialog(player: MainCharacter) -> Array[String]:
	return choose_dialog(
		player, 
		[
			"Hello, young one.",
			"Lost?... Well, perhaps this is fate.",
			"A small, golden ring has been misplaced.",
			"If you can find it, I'll reveal a secret that will aid you in your journey through this perilous place.",
			"Remember, dear one, that our magic can heal. Should you require our aid, seek us out, and we shall tend to your wounds."
		],
		[
			"You have found the Queen's treasure, a gift she bestowed upon me ages past. Now, it is yours to claim.",
			"The blessing of the butterflies is yours.",
			"With this power, you can dash with incredible speed and agility.",
			"Use \"Shift\" to activate this ability.",
			"Remember, though, to wield this power with respect and always cherish the beauty of the butterflies.",
		],
		[
			"Remember, you can activate dash ability by pressing \"Shift\"."
		])

func get_witch_2_dialog(player: MainCharacter) -> Array[String]:
	return choose_dialog(
		player, 
		[
			"Hello, young adventurer.",
			"My sister told me about your help finding the missing ring",
			"I could use your assistance once more.",
			"I accidentally dropped my necklace into the lake.",
			"I believe it might have washed downstream, somewhere deeper in the cave.",
			"If you can retrieve it, I'll share a secret that will aid you on your journey.",
			"Remember, our magic can heal. Seek us out if you need help."
		],
		[
			"You have found the Queen's treasure, a gift she bestowed upon me ages past. Now, it is yours to claim.",
			"The blessing of the butterflies is yours.",
			"With this power, you can dash with incredible speed and agility.",
			"Press \"Space\" once more when jumping to activate this ability.",
			"Remember, though, to wield this power with respect and always cherish the beauty of the butterflies.",
		],
		[
			"Remember, you can activate dash ability by pressing \"Space\" once more when jumping."
		])

func choose_dialog(player: MainCharacter,initial: Array[String], quest_finished: Array[String], repeat: Array[String]) -> Array[String]:
	var has_already_acquired_ability = ability_upgrade_name in player.abilities
	if quest_item_name in player.inventory and not has_already_acquired_ability:
		return quest_finished
	elif has_already_acquired_ability:
		return repeat
	
	return initial

func upgrade_player_ability(player: MainCharacter) -> void:
	var has_already_acquired_ability = ability_upgrade_name in player.abilities
	if quest_item_name in player.inventory and not has_already_acquired_ability:
		player.abilities.append(ability_upgrade_name)

func _on_cancel_interaction():
	DialogManager.stop_dialog()

extends Node2D

@export_subgroup("Settings")
@export_enum("Witch_1", "Witch_2", "Witch_3", "Witch_4", "Queen") var type
@export var quest_item_name: String
@export var ability_upgrade_name: String

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite = $AnimatedSprite2D

signal custom_event(event_name: String)

func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")
	interaction_area.cancel_interaction = Callable(self, "_on_cancel_interaction")
	
	match type:
		0: sprite.play("Witch_1")
		1: sprite.play("Witch_2")
		2: sprite.play("Witch_3")
		3: sprite.play("Witch_1")
		4: sprite.play("Queen")

func _on_interact():
	var player = Game.get_singleton().player
	player.event = true
	var dialog_lines: Array[String] = ["Sorry, I can't help you a this moment..."]

	match type:
		0:
			dialog_lines = get_witch_1_dialog(player)
		1:
			dialog_lines = get_witch_2_dialog(player)
		2:
			dialog_lines = get_witch_3_dialog(player)
		3:
			dialog_lines = [
					"A dead end, my dear. But what a peculiar dead end, isn't it?",
					"This portal intrigues me, but it seems to lead nowhere.",
					"Have you pondered where this portal might lead, if anywhere at all?"
				]
		4: dialog_lines = get_queen_dialog(player)
		_:
			pass
		

	DialogManager.start_dialog(global_position, dialog_lines)
	sprite.flip_h = true if interaction_area.get_overlapping_bodies()[0].global_position.x < global_position.x else false
	await DialogManager.dialog_finished
	player.event = false

	if type == 4 and has_player_collected_enough_leves():
		if not has_player_killed():
			custom_event.emit("good_ending")
		else:
			custom_event.emit("bad_ending")
	else:
		upgrade_player_ability(player)

	if player.has_something:
		player.heal(3)

func get_witch_1_dialog(player: MainCharacter) -> Array[String]:
	var dash_key = get_action_name_key("dash")
	
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
			"Use \"{0}\" to activate this ability.".format([dash_key]),
			"You can practice with nearby tree...",
			"Remember, though, to wield this power with respect and always cherish the beauty of the butterflies.",
		],
		[
			"You know, this tree only accepts bearers of the butterfly magic?",
			"I bet you should be capable of moving through!",
			"Remember, you can activate dash ability by pressing \"{0}\".".format([dash_key])
		])

func get_witch_2_dialog(player: MainCharacter) -> Array[String]:
	var jump_key = get_action_name_key("jump")
	
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
			"Press \"{0}\" once more when jumping to activate this ability.".format([jump_key]),
			"Remember, though, to wield this power with respect and always cherish the beauty of the butterflies.",
		],
		[
			"Remember, you can duble jump by pressing \"{0}\" midair.".format([jump_key])
		])

func get_witch_3_dialog(player: MainCharacter) -> Array[String]:
	var attack_key = get_action_name_key("attack")
	var atack_hint: Array[String] = [
		"Your journey has begun. What lies ahead is uncertain, but the path you've chosen will shape your destiny.",
		"In moments of despair, let your mana be your guiding light. Press the \"{0}\" button to unleash its power.".format([attack_key])
	]

	return choose_dialog(
		player, 
		[
			"This place was a haven until my pride shattered its peace.",
			"My sisters have turned their backs on me.",
			"If you choose to continue, you'll understand the darkness that awaits."
		],
		atack_hint,
		atack_hint)

func get_queen_dialog(player: MainCharacter) -> Array[String]:
	var negative_outcome: Array[String] = [
		"You have come a long way, young one.",
		"Your journey has not been in vain.",
		"Your actions have tainted your soul.",
		"You must return to the human world, you can't become one of us.",
		"I've opened a portal for you. Delay no longer."
	]
	
	var choose_outcome: Array[String] = [
		"A traveler has arrived.",
		"Your presence is both unexpected and welcome.",
		"Your heart is pure, and your spirit is strong.",
		"You may ascend to the realm of butterflies, or return to your mortal form.",
		"I've opened portals for you. It's time to choose."
	]
	
	var incomplete_outcome: Array[String] = [
		"An unexpected visitor has graced us with their presence.",
		"We welcome you, but...",
		"Your journey is not yet complete.",
		"Return to the forest and gather more leaves (at least {0}) before making your final choice.".format([7])
	]
	
	if not has_player_collected_enough_leves():
		return incomplete_outcome
	
	if has_player_killed():
		return negative_outcome
	
	return choose_outcome

func get_action_name_key(action_name: String) -> String:
	var action_event = InputMap.action_get_events(action_name)[0]
	
	if action_event == null:
		return "No key assigned for: {0}".format([action_name])
	
	return action_event.as_text().replace(" (Physical)", "")

func choose_dialog(player: MainCharacter,initial: Array[String], quest_finished: Array[String], repeat: Array[String]) -> Array[String]:
	var has_already_acquired_ability = ability_upgrade_name in player.abilities
	if quest_item_name in player.inventory and not has_already_acquired_ability:
		return quest_finished
	elif has_already_acquired_ability:
		return repeat
	
	return initial

func has_player_killed() -> bool:
	print(Game.get_singleton().kills)
	return Game.get_singleton().kills > 0

func has_player_collected_enough_leves() -> bool:
	return Game.get_singleton().collectibles >= 7

func upgrade_player_ability(player: MainCharacter) -> void:
	var has_already_acquired_ability = ability_upgrade_name in player.abilities
	if quest_item_name in player.inventory and not has_already_acquired_ability:
		player.add_ability(ability_upgrade_name)

func _on_cancel_interaction():
	DialogManager.stop_dialog()

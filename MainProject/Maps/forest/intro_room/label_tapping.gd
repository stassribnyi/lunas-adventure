extends Label

@export_subgroup("Settings")
@export var sfx_component: SFXComponent

func on_letter_show() -> void:
	sfx_component.play_letter_write()
	
var previous_value: Variant

func _set(property: StringName, value: Variant) -> bool:
	if property == "visible_characters" and self[property] < value and previous_value != value:
		previous_value = value
		sfx_component.play_letter_write()
	return false

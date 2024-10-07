extends Label

var interact: String

func _ready() -> void:
	update_mappings()

func _process(delta: float) -> void:
	if InputMap.action_get_events("interact")[0].as_text() != interact:
		update_mappings()

func update_mappings() -> void:
	interact = InputMap.action_get_events("interact")[0].as_text()
	
	text = "Use {0} to Talk and to see next sentence".format([interact.replace(" (Physical)", "")])

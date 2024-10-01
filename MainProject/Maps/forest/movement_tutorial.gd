extends Label

var move_left: String
var move_right: String
var jump: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_mappings()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (
		InputMap.action_get_events("move_left")[0].as_text() != move_left ||
		InputMap.action_get_events("move_right")[0].as_text() != move_right ||
		InputMap.action_get_events("jump")[0].as_text() != jump
	):
		update_mappings()

func update_mappings() -> void:
	move_left = InputMap.action_get_events("move_left")[0].as_text()
	move_right = InputMap.action_get_events("move_right")[0].as_text()
	jump = InputMap.action_get_events("jump")[0].as_text()
	
	text = "Use {0} or {1} to move Left or Right\nUse {2} to Jump".format([move_left.replace(" (Physical)", ""), move_right.replace(" (Physical)", ""), jump.replace(" (Physical)", "")])

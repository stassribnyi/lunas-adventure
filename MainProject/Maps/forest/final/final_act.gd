extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_queen_custom_event(event_name: String) -> void:
	match event_name:
		"good_ending":
			$FullMetamorphosis.show()
			$StayHuman.show()
			$FullMetamorphosis/Portal.enabled = true
			$StayHuman/Portal.enabled = true
		"bad_ending":
			$FullMetamorphosis.hide()
			$StayHuman.show()
			$FullMetamorphosis/Portal.enabled = false
			$StayHuman/Portal.enabled = true

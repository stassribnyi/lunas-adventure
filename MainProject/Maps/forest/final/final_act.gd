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
			$FullMetamorphosisLabel.show()
			$FullMetamorphosisPortal.show()
			$FullMetamorphosisPortal.enabled = true

			$StayHumanLabel.show()
			$StayHumanPortal.show()
			$StayHumanPortal.enabled = true
		"bad_ending":
			$FullMetamorphosisLabel.hide()
			$FullMetamorphosisPortal.hide()
			$FullMetamorphosisPortal.enabled = false	

			$StayHumanLabel.show()
			$StayHumanPortal.show()
			$StayHumanPortal.enabled = true

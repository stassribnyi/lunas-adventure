extends AnimatableBody2D

@export_subgroup("Settings")
@export_enum("Cobble", "Grass") var platform_type
@export_enum("None", "Grass", "Mushroom") var foliage_type

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_platform_look()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	set_platform_look()

func set_platform_look() -> void:
	match platform_type:
		0:
			$Grass.hide()
			$Cobble.show()
		_:
			$Grass.show()
			$Cobble.hide()

	match foliage_type:
		0:
			$Foliage.hide()
			$Foliage_2.hide()
		1:
			$Foliage.show()
			$Foliage_2.hide()
		2:
			$Foliage.hide()
			$Foliage_2.show()
		_:
			$Foliage.hide()
			$Foliage_2.hide()

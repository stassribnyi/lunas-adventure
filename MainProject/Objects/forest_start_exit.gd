extends StaticBody2D

@onready var barrier: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player: MainCharacter = Game.get_singleton().player
	
	var has_dash_ability = &"dash" in player.abilities
	
	barrier.disabled = has_dash_ability

extends Area2D
class_name InteractionArea

@export_subgroup("Settings")
@export var action_name: String = "Interact"

var interact: Callable = func():
	pass

var cancel_interaction: Callable = func():
	pass


func _on_body_entered(body: Node2D) -> void:
	InteractionManager.register_area(self)


func _on_body_exited(body: Node2D) -> void:
	InteractionManager.unregister_area(self)

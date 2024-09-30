extends Node2D

@onready var timer = $Timer

func start_dash(duration):
	timer.one_shot = true
	timer.start(duration)

func is_dashing():
	return !timer.is_stopped()

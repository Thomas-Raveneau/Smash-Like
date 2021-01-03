extends Node2D

func _ready():
	var camera = get_node("Player/Camera2D")
	camera._set_current(true)

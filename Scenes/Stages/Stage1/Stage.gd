extends Node2D

var camera

func _ready():
	if (get_tree().is_network_server()):
		get_node("Player2").set_network_master(get_tree().get_network_connected_peers()[0])
		camera = get_node("Player/Camera2D")
		camera._set_current(true)
	else:
		get_node("Player2").set_network_master(get_tree().get_network_unique_id())
		camera = get_node("Player2/Camera2D")
		camera._set_current(true)

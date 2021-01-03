extends Control

const DEFAULT_PORT = 6969

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _player_connected(id):
	var stage = load("res://Scenes/Stages/Stage1/Stage.tscn").instance()
	
	get_tree().get_root().add_child(stage)
	hide()

func _player_disconnected(id):
	if (get_tree().is_network_server()):
		_end_game("Client disconnected.")
	else:
		_end_game("Server disconnected.")

func _connected_ok():
	pass

func _connected_fail():
	_set_status("Couldn't connect.", false)
	
	get_tree().set_network_peer(null)
	
	get_node("Panel/Join").set_disabled(false)
	get_node("Panel/Host").set_disabled(false)


func _server_disconnected():
	_end_game("Server disconnected.")


func _end_game(with_error=""):
	if (has_node("/root/Stage")):
		get_node("/root/Stage").free()
		show()
	
	get_tree().call_deferred("set_network_peer", null)
	
	get_node("Panel/Join").set_disabled(false)
	get_node("Panel/Host").set_disabled(false)
	
	_set_status(with_error, false)


func _set_status(text, isok):
	if (isok):
		get_node("Panel/Status").set_text(text)
		get_node("Panel/Error").set_text("")
	else:
		get_node("Panel/Status").set_text("")
		get_node("Panel/Error").set_text(text)


func _on_Host_pressed():
	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	var err = host.create_server(DEFAULT_PORT, 1)
	if (err != OK):
		_set_status("Can't host, address already in use.",false)
		return
	
	get_tree().set_network_peer(host)
	
	get_node("Panel/Join").set_disabled(true)
	get_node("Panel/Host").set_disabled(true)
	_set_status("Waiting for player 2...", true)


func _on_Join_pressed():
	var ip = get_node("Panel/Label/Address").get_text()
	if (not ip.is_valid_ip_address()):
		_set_status("Invalid IP address.", false)
		return
	
	var host = NetworkedMultiplayerENet.new()
	host.set_compression_mode(NetworkedMultiplayerENet.COMPRESS_RANGE_CODER)
	host.create_client(ip, DEFAULT_PORT)
	get_tree().set_network_peer(host)
	
	_set_status("Connecting...",true)

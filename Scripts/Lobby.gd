extends Node2D

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")

func _on_ButtonHost_pressed():
	var net = NetworkedMultiplayerENet.new()
	net.create_server(8080, 2)
	get_tree().set_network_peer(net)
	print("hosting")

func _on_ButtonJoin_pressed():
	var net = NetworkedMultiplayerENet.new()
	net.create_client("127.0.0.1", 8080)
	get_tree().set_network_peer(net)
	
func _player_connected(id):
	Globals.player2id = id
	print('Player ', id, ' has joined')
	var game = preload("res://Scenes/Main/Game.tscn").instance()
	get_tree().get_root().add_child(game)
	hide()

func _player_disconnected(id):
	print('Player ', id, 'disconnected')

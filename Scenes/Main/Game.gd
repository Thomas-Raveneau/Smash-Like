extends Node2D

onready var player1pos = $Player1Pos
onready var player2pos = $Player2Pos

func _ready():
	var player1 = preload("res://Scenes/Player.tscn").instance()
	player1.set_name(str(get_tree().get_network_unique_id()))
	player1.set_network_master(get_tree().get_network_unique_id())
	player1.global_position = player1pos.global_position
	add_child(player1)
	
	var player2 = preload("res://Scenes/Player.tscn").instance()
	player2.set_name(str(Globals.player2id))
	player2.set_network_master(Globals.player2id)
	player2.global_position = player2pos.global_position
	add_child(player2)

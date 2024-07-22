extends Node

@onready var player = $"../../"
#@onready var respawn = $"/root/Level1/Respawn/RespawnNode2D"
@onready var respawn = $"../../../RespawnNode2D"


func respawn_player():
	player.position = respawn.position
	
func _ready():
	respawn_player()
	

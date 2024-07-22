extends Node

@onready var player = $".."
@onready var respawn = $"../../RespawnNode2D"
@onready var wand_point_light = $"../WandPointLight2D"

func respawn_player():
	player.position = respawn.position
	
func _ready():
	respawn_player()
	

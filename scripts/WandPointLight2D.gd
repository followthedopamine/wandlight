extends PointLight2D

var light_strength = 5
var initial_strength = light_strength
var light_decay = 0.7
var needs_respawn = false
@onready var player_respawn = $"../PlayerRespawn"

func check_failure_condition():
	if light_strength <= 0.1:
		player_respawn.respawn_player()
		light_strength = initial_strength

func decay_light(delta):
	if !needs_respawn:
		light_strength = light_strength - light_decay * delta
		self.texture_scale = light_strength
		check_failure_condition()

func _process(delta):
	decay_light(delta)

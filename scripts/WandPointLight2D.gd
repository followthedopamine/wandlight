extends PointLight2D

var light_strength = 3
var initial_strength = light_strength
var light_decay = 0.5
var light_charge_speed = 0.3
var light_damage = 0.4
var needs_respawn = false
var is_charging = false
@onready var player_respawn = $"../PlayerRespawn"

func check_failure_condition():
	if light_strength <= 0.01:
		player_respawn.respawn_player()
		light_strength = initial_strength

func decay_light(delta):
	if !needs_respawn:
		light_strength = light_strength - light_decay * delta
		check_failure_condition()
		
func charge_light(delta):
	light_strength = light_strength + light_charge_speed * delta
	
func update_light_texture():
	self.texture_scale = light_strength
	
func damage_light():
	light_strength = light_strength - light_damage
	check_failure_condition()
	update_light_texture()

func _input(event):
	if event.is_action_pressed("charge"):
		is_charging = true
	elif event.is_action_released("charge"):
		is_charging = false

func _process(delta):
	if is_charging:
		charge_light(delta)
	else:
		decay_light(delta)
	update_light_texture()
	

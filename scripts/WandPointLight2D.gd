extends PointLight2D

@onready var player = $".."
@onready var light_circle = $"../LightCircleArea2D"


var light_strength = 2
var initial_strength = light_strength
var light_decay = 0.5
var light_charge_speed = 0.6
var light_damage = 0.4
var needs_respawn = false
var is_charging = false

func check_failure_condition():
	if light_strength <= 0.01:
		get_tree().reload_current_scene()

func decay_light(delta):
	if !needs_respawn:
		light_strength = light_strength - light_decay * delta
		check_failure_condition()
		
func charge_light(delta):
	light_strength = light_strength + light_charge_speed * delta
	
func update_light():
	self.texture_scale = light_strength
	light_circle.scale = Vector2(light_strength,light_strength)
	
	
func damage_light():
	light_strength = light_strength - light_damage
	check_failure_condition()
	update_light()

func _input(event):
	if event.is_action_pressed("charge"):
		if player.remaining_damage_cooldown == 0:
			is_charging = true
		else:
			is_charging = false
	elif event.is_action_released("charge"):
		is_charging = false

func _process(delta):
	if !player.is_paused:
		if is_charging:
			charge_light(delta)
		else:
			decay_light(delta)
		update_light()
	

extends CharacterBody2D

@export var speed = 200
@onready var animations = $AnimationPlayer
@onready var collision = $PlayerCollisionShape2D

var is_rolling = false
const roll_cooldown = 1.5
const roll_duration = 0.8
const roll_speed = 1.2
var remaining_roll_cooldown = 0
var remaining_roll_duration = 0


func get_input():
	if !is_rolling:
		var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		velocity = input_direction * speed
	if Input.is_action_just_pressed("roll"):
		roll()
		
func roll():
	if remaining_roll_cooldown <= 0:
		remaining_roll_cooldown = roll_cooldown
		remaining_roll_duration = roll_duration
		is_rolling = true
		velocity *= roll_speed
		#Disable collision with enemies
		disable_enemy_collision()

func disable_enemy_collision():
	set_collision_mask_value(3,false)
	
func enable_enemy_collision():
	set_collision_mask_value(3,true)

func update_animation():
	if velocity.length() == 0:
		animations.stop()
	var direction = "down"
	if velocity.x < 0: 
		direction = "left"
	elif velocity.x > 0: 
		direction="right"
	elif velocity.y < 0:
		direction = "up"
	
	if is_rolling:
		animations.play("roll_" + direction)
	else:
		animations.play("walk_" + direction)
	
func _physics_process(_delta):
	get_input()
	move_and_slide()
	update_animation()

func _process(delta):
	if remaining_roll_cooldown > 0:
		remaining_roll_cooldown = remaining_roll_cooldown - delta
	else:
		remaining_roll_cooldown = 0
	if remaining_roll_duration > 0:
		remaining_roll_duration = remaining_roll_duration - delta
	else:
		remaining_roll_duration = 0
		is_rolling = false
		enable_enemy_collision()

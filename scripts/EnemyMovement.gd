extends CharacterBody2D

const SPEED = 80

@onready var player = $"../Player/PlayerCharacterBody2D"
@onready var attack_timer = $AttackTimer
@onready var animations = $EnemyAnimationPlayer
@onready var enemy_collision = $EnemyCollisionShape2D
@onready var nav = $NavigationAgent2D
@onready var enemy_sprite = $EnemySprite2D


enum {
	WAITING,
	SURROUND,
	ATTACK,
	HIT,
}

var state = WAITING

var randomnum
var rng = RandomNumberGenerator.new()
var last_direction = "down"

func _ready():
	rng.randomize()
	randomnum = rng.randf()

func move(target, delta):
	nav.target_position = target
	var direction = (nav.get_next_path_position() - global_position).normalized()
	var desired_velocity = direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity+= steering
	move_and_slide()
	
func get_circle_position(random):
	var kill_circle_centre = player.global_position
	var radius = 50
	var angle = random * PI * 2
	var x = kill_circle_centre.x + cos(angle) * radius
	var y = kill_circle_centre.y + sin(angle) * radius
	
	return Vector2(x,y)
	
func update_animation():
	if state != HIT:
		if velocity.length() == 0:
			animations.stop()
		last_direction = "down"
		if(abs(velocity.x) > abs(velocity.y)):
			if velocity.x < 0: 
				last_direction = "left"
			elif velocity.x > 0: 
				last_direction = "right"
		elif velocity.y < 0:
			last_direction = "up"
		animations.play("enemy_walk_" + last_direction)
		print("enemy_walk_" + last_direction)
		print(enemy_sprite.texture)
	
func handle_collision():
	for i in get_slide_collision_count():
		var collider = get_slide_collision(i).get_collider()
		if collider.name.to_lower().contains("player"):
			if player.remaining_damage_cooldown == 0:
				state = HIT
				animations.play("enemy_attack_" + last_direction)
				await get_tree().create_timer(0.8).timeout
				state = SURROUND
				break
	
func _on_attack_timer_timeout():
	match state:
		ATTACK:
			randomnum = rng.randf()
			state = SURROUND
		SURROUND:
			state = ATTACK
	print("Changed state")
	
func _on_enemy_aggro_area_2d_area_entered(_area):
	state = SURROUND

func _on_enemy_aggro_area_2d_area_exited(_area):
	state = WAITING
	
func _physics_process(delta):
	if !player.is_paused:
		update_animation()
		handle_collision()
		if player.is_rolling:
			enemy_collision.disabled = true
		else:
			enemy_collision.disabled = false	
		match state:
			SURROUND:
				move(get_circle_position(randomnum), delta)
			ATTACK:
				move(player.global_position, delta)







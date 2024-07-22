extends Area2D

@onready var camera = $"../Player/PlayerCharacterBody2D/Camera2D"
@onready var door = $"../DoorStaticBody2D"
@onready var door_animation = $"../DoorStaticBody2D/DoorAnimationPlayer"
@onready var lever_animation = $LeverAnimationPlayer
@onready var player = $"../Player/PlayerCharacterBody2D"



var camera_panning = false
var camera_target
var animation_playing = false

func stop_time():
	player.is_paused = true
	
func play_lever_animation():
	animation_playing = true
	lever_animation.play("pull_lever")

func pan_to_door():
	camera_panning = true
	camera_target = door
	print("pan to door is called")
	
func play_door_animation():
	door_animation.play("open_door")
	pass

func pan_to_player():
	camera_panning = true
	camera_target = player
	
func start_time():
	player.is_paused = false
	
func pan_camera(target, speed, delta):
	print("camera is panning")
	camera.global_position = camera.global_position.move_toward(target.global_position, speed * delta)
	if camera.global_position == target.global_position:
		camera_panning = false
		
func remove_door_collision():
	print("Door collision removed")
	door.set_collision_layer_value(1,false)

func open_door():
	print("Attempting to open door")
	stop_time()
	play_lever_animation()
	await get_tree().create_timer(1.0).timeout
	pan_to_door()
	await get_tree().create_timer(1.0).timeout
	play_door_animation()
	await get_tree().create_timer(1.3).timeout
	pan_to_player()
	await get_tree().create_timer(1.0).timeout
	remove_door_collision()
	start_time()

func _on_body_entered(body):
	print(body)
	open_door()
	
func _process(delta):
	if !lever_animation.is_playing() and !door_animation.is_playing():
		if camera_panning:
			pan_camera(camera_target, 250, delta)
		if !camera_panning and !animation_playing:
			start_time()
		

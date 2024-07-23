extends Node

@onready var player = $"../"
@onready var player_sprite = $"../PlayerSprite2D"

@onready var respawn = $"../../../RespawnNode2D"
@onready var respawn_animation = $"../../../RespawnNode2D/RespawnAnimationPlayer"

func hide_player():
	player.is_paused = true
	player_sprite.visible = false
	
func play_respawn_animation():
	respawn_animation.play("respawn")
	
func show_player():
	player.is_paused = false
	player_sprite.visible = true

func respawn_player():
	player.global_position = respawn.global_position
	
	hide_player()
	play_respawn_animation()
	await get_tree().create_timer(0.9).timeout
	show_player()
	
func _ready():
	respawn_player()
	

extends Area2D

@export var next_level = "Level2"
@onready var ladder_animation = $LadderAnimationPlayer
@onready var player_sprite = $"../Player/PlayerCharacterBody2D/PlayerSprite2D"
@onready var player = $"../Player/PlayerCharacterBody2D"

func hide_player():
	player_sprite.visible = false
	player.is_paused = true
	player.global_position = global_position

func play_ladder_animation():
	hide_player()
	ladder_animation.play("climb_down")

func go_to_next_level():
	print("Next level")
	play_ladder_animation()
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://scenes/" + next_level + ".tscn")
	pass

func _on_body_entered(_body): #TODO Only player should be able to activate end level
	call_deferred("go_to_next_level")

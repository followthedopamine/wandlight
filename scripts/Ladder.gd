extends Area2D

@export var next_level = "Level2"

func go_to_next_level():
	print("Next level")
	get_tree().change_scene_to_file("res://scenes/" + next_level + ".tscn")
	pass

func _on_body_entered(_body): #TODO Only player should be able to activate end level
	call_deferred("go_to_next_level")

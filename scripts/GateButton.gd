extends Area2D

@onready var gate = $"../GateStaticBody2D"

func _on_body_entered(body):
	gate.queue_free()

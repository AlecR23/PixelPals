class_name SlipperyFloor
extends Area2D

@export var background: Node2D


func _process(_delta):
	if background.visible:
		self.monitoring = true
	else:
		self.monitoring = false


func _on_body_entered(body):
	body.on_slippery_surface = true


func _on_body_exited(body):
	body.on_slippery_surface = false

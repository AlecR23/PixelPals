class_name Animator
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state_machine = animation_tree.get("parameters/playback")

var movement_locked: bool = false


func set_animation(new_animation: String, direction: float):
	var path: String = "parameters/" + new_animation + "/blend_position"
	animation_tree.set(path, direction)
	animation_state_machine.travel(new_animation)


func lock_entity_movement():
	movement_locked = true

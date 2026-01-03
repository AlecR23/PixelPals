class_name TitleScreen
extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state_machine = animation_tree.get("parameters/playback")

@onready var start_button = $StartButton


func set_animation(new_animation: String, direction: float):
	var path: String = "parameters/" + new_animation + "/blend_position"
	animation_tree.set(path, direction)
	animation_state_machine.travel(new_animation)


func begin_title_animation():
	set_animation("show_icon", 0)


func show_icon_finished():
	set_animation("show_title", 0)


func show_title_finished():
	set_animation("show_start", 0)


func show_start_finished():
	start_button.visible = true
	start_button.disabled = false

class_name Selector
extends Control

@export var icon_container: IconContainer

@export var right_arrow: TextureButton
@export var left_arrow: TextureButton
@export var esc_button: TextureButton
@export var hanging_esc_button: TextureButton

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state_machine = animation_tree.get("parameters/playback")

var current_selection: int = 0

enum selection{
	PLAYER,
	BACKGROUND,
	OPTIONS
}


func _ready():
	set_animation("Closed", 0)
	esc_button.visible = true


func _physics_process(_delta):
	if Input.is_action_just_pressed("pause"):
		_toggle_pause()
	
	if not global_variables.game_is_paused:
		return
	
	if Input.is_action_just_pressed("move_left"):
		iterate_current_selection(-1)
	if Input.is_action_just_pressed("move_right"):
		iterate_current_selection(1)


func _toggle_pause():
	if global_variables.game_is_paused:
		set_animation("Closing", 0)
		icon_container.hide_icons()
		hide_arrows()
		hanging_esc_button.visible = false
		global_variables.game_is_paused = false
	else:
		set_animation("Opening", 0)
		esc_button.visible = false
		global_variables.game_is_paused = true


func iterate_current_selection(value):
	var unadjusted_value: int = current_selection + value
	if unadjusted_value < 0:
		current_selection = 2
	elif unadjusted_value > 2:
		current_selection = 0
	else:
		current_selection = unadjusted_value
	match_selection(current_selection)


func match_selection(i):
	match i:
		selection.PLAYER:
			set_animation("Player", 0)
		selection.BACKGROUND:
			set_animation("Background", 0)
		selection.OPTIONS:
			set_animation("Options", 0)
	icon_container.hide_icons()
	icon_container.display_icons(current_selection)


func set_animation(new_animation: String, direction: float):
	var path: String = "parameters/" + new_animation + "/blend_position"
	animation_tree.set(path, direction)
	animation_state_machine.travel(new_animation)


func on_opening_finished():
	match_selection(current_selection)
	icon_container.hide_icons()
	icon_container.display_icons(current_selection)
	display_arrows()
	display_hanging_esc()


func display_arrows():
	right_arrow.visible = true
	left_arrow.visible = true


func display_hanging_esc():
	hanging_esc_button.visible = true


func hide_arrows():
	right_arrow.visible = false
	left_arrow.visible = false


func on_closing_finished():
	esc_button.visible = true

class_name Entity
extends CharacterBody2D

@onready var animator: Animator = $Animator
@onready var state_machine: StateMachine = $StateMachine
@onready var inputs: Inputs = $Inputs
@onready var blooblepop = $Blooblepop

@export var bonk_state: BonkState
@export var startle_state: StartleState

@export var player_driver: InputsDriver
@export var computer_driver: InputsDriver
@export var speed: float = 30.0
@export var facing: int = 0
@export var emote_count: int = 1

@export var on_slippery_surface: bool = false
@export var is_startled: bool = false
var startle_queued := false

var bonk_queued: bool = false
var bonk_knock_dir: int = 0  # -1 = knock left, +1 = knock right


enum InputSource {
	COMPUTER,
	PLAYER
	}


func _ready() -> void:
	state_machine.init(self)
	inputs.set_driver(computer_driver)


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)


func _physics_process(delta: float) -> void:
	if is_startled and startle_state != null:
		is_startled = false             # consume the trigger (so it doesn't re-enter every frame)
		startle_queued = false
		state_machine.change_state(startle_state)
		return
	
	if startle_queued and startle_state != null:
		startle_queued = false
		state_machine.change_state(startle_state)
		return
	
	# Consume queued bonk before normal processing
	if bonk_queued and bonk_state != null:
		bonk_queued = false
		bonk_state.knock_dir = bonk_knock_dir
		state_machine.change_state(bonk_state)
		return
	
	state_machine.process_physics(delta)


func _process(delta: float) -> void:
	state_machine.process_frame(delta)


func set_running_collisions(enabled: bool) -> void:
	set_collision_layer_value(5, enabled)
	set_collision_mask_value(2, true)
	set_collision_mask_value(3, true)
	set_collision_mask_value(1, false)
	set_collision_mask_value(5, enabled)


func set_input(source: int) -> void:
	match source:
		InputSource.COMPUTER:
			blooblepop.visible = false
			inputs.set_driver(computer_driver)
		InputSource.PLAYER:
			blooblepop.visible = true
			inputs.set_driver(player_driver)


func queue_startle() -> void:
	if startle_queued:
		return
	startle_queued = true


func queue_bonk(knock_dir: int) -> void:
	if bonk_queued:
		return
	bonk_queued = true
	bonk_knock_dir = 1 if knock_dir >= 0 else -1

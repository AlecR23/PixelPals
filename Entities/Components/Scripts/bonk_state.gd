class_name BonkState
extends State

@export var stand_state: StandState

@export var animation_left: String = "bonk_left"
@export var animation_right: String = "bonk_right"
@export var knockback_speed: float = 5.0   # set 0 to disable
@export var lock_time_scale: float = 1.0    # 1.0 = normal speed

var duration: float = 0.0
var timer: float = 0.0
var started: bool = false
var apply_knockback: bool = true
var directional_animation_name: String = ""

var knock_dir: int = 0  # -1 or +1 (direction we get knocked toward)


func enter() -> void:
	started = false
	timer = 0.0
	duration = 0.0
	apply_knockback = true

	# Decide knock direction:
	# If not provided, fall back to "opposite of facing"
	if knock_dir == 0:
		knock_dir = -entity.facing

	# Face opposite of knock so the animation looks right (optional)
	entity.facing = -knock_dir

	directional_animation_name = (animation_right if entity.facing > 0 else animation_left)
	entity.animator.set_animation(animation_name, float(entity.facing))

	var ap := entity.animator.animation_player
	if not ap.get_animation(directional_animation_name):
		return
	duration = ap.get_animation(directional_animation_name).length

	if knockback_speed > 0.0:
		entity.velocity.x = float(knock_dir) * knockback_speed


func exit() -> void:
	entity.animator.movement_locked = false
	started = false
	timer = 0.0
	duration = 0.0
	Engine.time_scale = 1.0  # restore


func process_physics(delta: float) -> State:
	if not animation_left or not animation_right:
		return stand_state
	
	if not started:
		started = true
	
	timer += delta
	
	if timer >= duration:
		return stand_state
	
	if entity.animator.movement_locked == true:
		entity.velocity.x = 0
	else:
		entity.velocity.y += gravity * delta
	entity.move_and_slide()
	return null

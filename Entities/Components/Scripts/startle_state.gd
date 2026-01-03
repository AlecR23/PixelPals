class_name StartleState
extends State

@export var stand_state: StandState
@export var anim_name: String = "Startle"

var _done := false


func enter() -> void:
	_done = false
	entity.animator.set_animation(anim_name, float(entity.facing))


func exit() -> void:
	entity.is_startled = false
	_done = false


func process_physics(delta: float) -> State:
	if _done:
		return stand_state
	
	entity.velocity.y += gravity * delta
	entity.move_and_slide()
	return null


func startle_finished() -> void:
	_done = true

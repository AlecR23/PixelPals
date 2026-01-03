class_name WalkState
extends State

@export var stand_state: StandState
@export var run_state: RunState


func enter() -> void:
	super()
	entity.set_running_collisions(false)


func process_physics(delta: float) -> State:
	var direction: int = int(state_machine.inputs.input_direction)
	
	if direction == 0:
		return stand_state
	if state_machine.inputs.input_run:
		return run_state
	
	var target_x := float(direction) * move_speed
	_apply_horizontal(target_x, delta)
	
	entity.velocity.y += gravity * delta
	entity.facing = direction
	entity.animator.set_animation(animation_name, float(direction))
	
	entity.move_and_slide()
	
	if _hit_layer(3):
		entity.velocity.x = -entity.velocity.x
		entity.facing = -entity.facing
	
	return null

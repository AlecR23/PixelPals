class_name StandState
extends State

@export var walk_state: WalkState
@export var emote_states: Array[EmoteState] = []
@export var run_state: RunState


func enter() -> void:
	entity.set_running_collisions(false)
	entity.animator.set_animation(animation_name, float(entity.facing))


func process_physics(delta: float) -> State:
	if state_machine.inputs.emote_key != 0:
		var id := state_machine.inputs.emote_key
		state_machine.inputs.emote_key = 0
		var idx := id - 1  # emote 1 -> slot 0, emote 2 -> slot 1, etc.
		if idx >= 0 and idx < emote_states.size() and emote_states[idx] != null:
			var st := emote_states[idx]
			st.emote_id = id
			return st
		else:
			push_warning("StandState: No EmoteState configured for emote_id=%d (index=%d)" % [id, idx])
			return null
	
	if state_machine.inputs.face_front:
		state_machine.inputs.face_front = false
		entity.animator.set_animation(animation_name, 0.0)
		return null
	
	var left := state_machine.inputs.input_left
	var right := state_machine.inputs.input_right
	if left != right:
		if state_machine.inputs.input_run:
			return run_state
		return walk_state
	
	_apply_horizontal(0.0, delta)
	
	entity.velocity.y += gravity * delta
	entity.move_and_slide()
	return null

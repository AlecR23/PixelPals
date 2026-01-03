class_name RunState
extends State

@export var stand_state: StandState
@export var walk_state: WalkState
@export var bonk_state: BonkState

@export var run_speed_multiplier: float = 1.6
@export var animation_name_run: String = "run"

const RUNNING_LAYER := 5


func enter() -> void:
	entity.set_running_collisions(true)


func exit() -> void:
	entity.set_running_collisions(false)


func process_physics(delta: float) -> State:
	var direction := int(state_machine.inputs.input_direction)
	
	if direction == 0:
		return stand_state
	if not state_machine.inputs.input_run:
		return walk_state
	
	var speed := move_speed * run_speed_multiplier
	var target_x := float(direction) * speed
	_apply_horizontal(target_x, delta)
	
	entity.velocity.y += gravity * delta
	entity.facing = direction
	entity.animator.set_animation(animation_name_run, float(direction))
	
	entity.move_and_slide()
	
	if _hit_layer(3):
		bonk_state.knock_dir = -entity.facing
		return bonk_state
	
	for i in range(entity.get_slide_collision_count()):
		var c := entity.get_slide_collision(i)
		var collider := c.get_collider()
	
		if collider == null or not (collider is CollisionObject2D):
			continue
		if not collider.get_collision_layer_value(RUNNING_LAYER):
			continue
	
		var n := c.get_normal()
		var self_knock_dir := (1 if n.x > 0 else -1) if absf(n.x) > 0.01 else -entity.facing
	
		if collider is Entity:
			(collider as Entity).queue_bonk(-self_knock_dir)
	
		bonk_state.knock_dir = self_knock_dir
		return bonk_state

	return null

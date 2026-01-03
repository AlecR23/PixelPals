class_name State
extends Node

@onready var state_machine: StateMachine = $".."

@export var animation_name: String = ""
@export var move_speed: float = 20.0

@export var accel_ground: float = 1200.0
@export var decel_ground: float = 1400.0
@export var accel_slippery: float = 10.0
@export var decel_slippery: float = 5.0

@export var stop_epsilon: float = 2.0 # How small velocity must be before we clamp to 0 

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var entity: Entity


func enter() -> void:
	entity.animator.set_animation(animation_name, 0.0)


func exit() -> void:
	pass


func process_input(_event: InputEvent) -> State:
	return null


func process_frame(_delta: float) -> State:
	return null


func process_physics(_delta: float) -> State:
	return null


func _hit_layer(layer_bit: int) -> bool:
	for i in range(entity.get_slide_collision_count()):
		var c := entity.get_slide_collision(i)
		var collider := c.get_collider()
		if collider != null and collider is CollisionObject2D:
			if collider.get_collision_layer_value(layer_bit):
				return true
	return false


func _get_accel() -> float:
	return accel_slippery if entity.on_slippery_surface else accel_ground


func _get_decel() -> float:
	return decel_slippery if entity.on_slippery_surface else decel_ground


# Moves velocity.x toward target_x using accel/decel depending on if you're pushing or not.
func _apply_horizontal(target_x: float, delta: float) -> void:
	var rate: float
	if absf(target_x) > 0.001:
		rate = _get_accel()
	else:
		rate = _get_decel()
	
	entity.velocity.x = move_toward(entity.velocity.x, target_x, rate * delta)
	
	# Clamp tiny drift
	if absf(target_x) < 0.001 and absf(entity.velocity.x) < stop_epsilon:
		entity.velocity.x = 0.0

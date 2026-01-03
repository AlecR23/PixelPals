class_name PlayerDriver
extends InputsDriver


func physics_update(_entity: Entity, inputs: Inputs, _delta: float) -> void:
	inputs.emote_key = 0
	inputs.face_front = Input.is_action_just_pressed("face_front")

	var left := Input.is_action_pressed("move_left")
	var right := Input.is_action_pressed("move_right")
	inputs.input_direction = int(right) - int(left)

	inputs.input_left = left
	inputs.input_right = right
	inputs.input_run = Input.is_action_pressed("run")

	if inputs.input_direction == 0 and Input.is_action_just_pressed("emote_1"):
		inputs.emote_key = 1
	if inputs.input_direction == 0 and Input.is_action_just_pressed("emote_2"):
		inputs.emote_key = 2

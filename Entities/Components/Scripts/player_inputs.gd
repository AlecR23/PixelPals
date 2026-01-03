class_name UserInputs
extends Inputs

@export var inputs_active: bool = false


func _physics_process(_delta):
	if not inputs_active:
		return
	
	var left: float = Input.is_action_pressed("move_left")
	var right: float = Input.is_action_pressed("move_right")
	var direction: int = int(right) - int(left)   # -1, 0, or 1
	
	if global_variables.game_is_paused:
		input_direction = 0
		return
	
	input_left = left
	input_right = right
	input_direction = direction
	input_run = Input.is_action_pressed("run")
	face_front = Input.is_action_pressed("face_front")
	
	if input_direction == 0:
		if Input.is_action_just_pressed("emote_1"):
			emote_key = 1
		#elif Input.is_action_just_pressed("emote_2"):
			#emote_key = 2
		#elif Input.is_action_just_pressed("emote_3"):
			#emote_key = 3
		#elif Input.is_action_just_pressed("emote_4"):
			#emote_key = 4

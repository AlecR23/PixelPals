class_name ComputerInputs
extends Inputs

# ----- CONFIG -----
@export var walk_timer: TimerData
@export var run_timer: TimerData
@export var idle_timer: TimerData
@export var emote_timer: TimerData
@export var face_front_timer: TimerData

@export var wall_group: String = "world_bounds"

@export var emote_chance: float = 0.5
@export var run_from_idle_chance: float = 0.35   # chance to start running from idle
@export var run_continue_chance: float = 0.25    # chance to chain another run period

@export var inputs_active: bool = true:
	set(value):
		if inputs_active == value:
			return
		inputs_active = value
		_apply_inputs_active()

# ----- TIMERS -----
var _state_timer: Timer
var _emote_timer: Timer
var _face_front_timer: Timer

var _is_walking : bool = false
var _is_running : bool = false

func _ready() -> void:
	randomize()
	_state_timer = _make_one_shot_timer(_on_state_timeout)
	_emote_timer = _make_one_shot_timer(_on_emote_timeout)
	_face_front_timer = _make_one_shot_timer(_on_face_front_timeout)
	_apply_inputs_active()



func _physics_process(_delta: float) -> void:
	if not inputs_active: return
	input_left  = input_direction == -1
	input_right = input_direction == 1
	input_run   = _is_running
	
	if _is_walking and entity.is_on_wall():
		var flipped := _maybe_flip_from_collision()
		if flipped:
			input_left  = input_direction == -1
			input_right = input_direction == 1


func _apply_inputs_active() -> void:
	set_physics_process(inputs_active)
	
	if not inputs_active:
		if _state_timer: _state_timer.stop()
		if _emote_timer: _emote_timer.stop()
		if _face_front_timer: _face_front_timer.stop()
	
		_is_walking = false
		_is_running = false
		input_direction = 0
		input_left = false
		input_right = false
		input_run = false
		emote_key = 0
		face_front = false
	else:
		_start_idle_cycle()



# ---------------------------------------------------------------
# -------------------- STATE CHANGE LOGIC ------------------------
# ---------------------------------------------------------------

func _on_state_timeout() -> void:
	if not inputs_active: return
	if _is_running:
		if randf() < run_continue_chance:
			_start_run_cycle()
		else:
			_start_idle_cycle()
	elif _is_walking:
		_start_idle_cycle()
	else:
		if randf() < run_from_idle_chance:
			_start_run_cycle()
		else:
			_start_walk_cycle()


func _start_walk_cycle() -> void:
	_is_walking = true
	_is_running = false
	input_run = false
	input_direction = [-1, 1].pick_random()
	_emote_timer.stop()
	_face_front_timer.stop()
	_state_timer.wait_time = randf_range(walk_timer.interval_min, walk_timer.interval_max)
	_state_timer.start()


func _start_run_cycle() -> void:
	_is_walking = false
	_is_running = true
	input_run = true
	input_direction = [-1, 1].pick_random()
	_emote_timer.stop()
	_face_front_timer.stop()
	_state_timer.wait_time = randf_range(run_timer.interval_min, run_timer.interval_max)
	_state_timer.start()


func _start_idle_cycle() -> void:
	_is_walking = false
	_is_running = false
	input_run = false
	input_direction = 0
	_state_timer.wait_time = randf_range(idle_timer.interval_min, idle_timer.interval_max)
	_state_timer.start()
	_rearm_emote()
	_rearm_face_front()



# ---------------------------------------------------------------
# -------------------- EMOTE / FACE FRONT ------------------------
# ---------------------------------------------------------------

func _on_emote_timeout() -> void:
	if not inputs_active: return
	if not _is_walking and not _is_running and randf() < emote_chance:
		emote_key = randi_range(1, 1)
	_rearm_emote()


func _on_face_front_timeout() -> void:
	if not inputs_active: return
	if not _is_walking and not _is_running:
		face_front = true
	_rearm_face_front()


func _maybe_flip_from_collision() -> bool:
	var count := entity.get_slide_collision_count()
	for i in count:
		var col: KinematicCollision2D = entity.get_slide_collision(i)
		if abs(col.get_normal().x) > 0.5:
			input_direction = int(sign(col.get_normal().x))
			return true
	return false


# ---------------------------------------------------------------
# -------------------- TIMER HELPERS -----------------------------
# ---------------------------------------------------------------


func _make_one_shot_timer(callback: Callable) -> Timer:
	var t := Timer.new()
	t.one_shot = true
	add_child(t)
	t.timeout.connect(callback)
	return t


func _rearm_emote() -> void:
	if not inputs_active: return
	_emote_timer.wait_time = randf_range(emote_timer.interval_min, emote_timer.interval_max)
	_emote_timer.start()


func _rearm_face_front() -> void:
	if not inputs_active: return
	_face_front_timer.wait_time = randf_range(face_front_timer.interval_min, face_front_timer.interval_max)
	_face_front_timer.start()

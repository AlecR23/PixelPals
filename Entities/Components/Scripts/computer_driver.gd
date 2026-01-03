class_name ComputerDriver
extends InputsDriver

# ----- CONFIG -----
@export var walk_timer: TimerData
@export var run_timer: TimerData
@export var idle_timer: TimerData
@export var emote_timer: TimerData
@export var face_front_timer: TimerData

@export var emote_chance: float = 0.5
@export var run_from_idle_chance: float = 0.35
@export var run_continue_chance: float = 0.25

# ----- RUNTIME -----
var _state_timer: Timer
var _emote_timer: Timer
var _face_front_timer: Timer

var _is_walking := false
var _is_running := false

var _dir := 0


func enter(entity: Entity, inputs: Inputs) -> void:
	randomize()
	
	_state_timer = _make_one_shot_timer(entity, func(): _on_state_timeout(entity, inputs))
	_emote_timer = _make_one_shot_timer(entity, func(): _on_emote_timeout(entity, inputs))
	_face_front_timer = _make_one_shot_timer(entity, func(): _on_face_front_timeout(entity, inputs))
	
	_start_idle_cycle(entity, inputs)


func exit(_entity: Entity, inputs: Inputs) -> void:
	_stop_and_free(_state_timer)
	_stop_and_free(_emote_timer)
	_stop_and_free(_face_front_timer)
	
	_state_timer = null
	_emote_timer = null
	_face_front_timer = null
	
	_is_walking = false
	_is_running = false
	_dir = 0
	
	inputs.clear()


func physics_update(entity: Entity, inputs: Inputs, _delta: float) -> void:
	inputs.input_direction = _dir
	inputs.input_left = _dir == -1
	inputs.input_right = _dir == 1
	inputs.input_run = _is_running
	
	if _is_walking and entity.is_on_wall():
		var flipped := _maybe_flip_from_collision(entity)
		if flipped:
			inputs.input_direction = _dir
			inputs.input_left = _dir == -1
			inputs.input_right = _dir == 1



# ---------------------------------------------------------------
# -------------------- STATE CHANGE LOGIC ------------------------
# ---------------------------------------------------------------

func _on_state_timeout(entity: Entity, inputs: Inputs) -> void:
	if _is_running:
		if randf() < run_continue_chance:
			_start_run_cycle(entity, inputs)
		else:
			_start_idle_cycle(entity, inputs)
	elif _is_walking:
		_start_idle_cycle(entity, inputs)
	else:
		if randf() < run_from_idle_chance:
			_start_run_cycle(entity, inputs)
		else:
			_start_walk_cycle(entity, inputs)


func _start_walk_cycle(_entity: Entity, _inputs: Inputs) -> void:
	_is_walking = true
	_is_running = false
	_dir = [-1, 1].pick_random()
	
	_emote_timer.stop()
	_face_front_timer.stop()
	
	_state_timer.wait_time = randf_range(walk_timer.interval_min, walk_timer.interval_max)
	_state_timer.start()


func _start_run_cycle(_entity: Entity, _inputs: Inputs) -> void:
	_is_walking = false
	_is_running = true
	_dir = [-1, 1].pick_random()

	_emote_timer.stop()
	_face_front_timer.stop()

	_state_timer.wait_time = randf_range(run_timer.interval_min, run_timer.interval_max)
	_state_timer.start()


func _start_idle_cycle(entity: Entity, inputs: Inputs) -> void:
	_is_walking = false
	_is_running = false
	_dir = 0

	_state_timer.wait_time = randf_range(idle_timer.interval_min, idle_timer.interval_max)
	_state_timer.start()

	_rearm_emote(entity, inputs)
	_rearm_face_front(entity, inputs)



# ---------------------------------------------------------------
# -------------------- EMOTE / FACE FRONT ------------------------
# ---------------------------------------------------------------

func _on_emote_timeout(entity: Entity, inputs: Inputs) -> void:
	if not _is_walking and not _is_running and randf() < emote_chance:
		var n = max(1, entity.emote_count)
		inputs.emote_key = randi_range(1, n)
	
	_rearm_emote(entity, inputs)


func _on_face_front_timeout(entity: Entity, inputs: Inputs) -> void:
	if not _is_walking and not _is_running:
		inputs.face_front = true
	
	_rearm_face_front(entity, inputs)


func _rearm_emote(_entity: Entity, _inputs: Inputs) -> void:
	if _emote_timer == null:
		return
	_emote_timer.wait_time = randf_range(emote_timer.interval_min, emote_timer.interval_max)
	_emote_timer.start()


func _rearm_face_front(_entity: Entity, _inputs: Inputs) -> void:
	if _face_front_timer == null:
		return
	_face_front_timer.wait_time = randf_range(face_front_timer.interval_min, face_front_timer.interval_max)
	_face_front_timer.start()


# ---------------------------------------------------------------
# -------------------- COLLISION FLIP ----------------------------
# ---------------------------------------------------------------

func _maybe_flip_from_collision(entity: Entity) -> bool:
	var count := entity.get_slide_collision_count()
	for i in count:
		var col: KinematicCollision2D = entity.get_slide_collision(i)
		if abs(col.get_normal().x) > 0.5:
			_dir = int(sign(col.get_normal().x))
			return true
	return false



# ---------------------------------------------------------------
# -------------------- TIMER HELPERS -----------------------------
# ---------------------------------------------------------------

func _make_one_shot_timer(parent: Node, callback: Callable) -> Timer:
	var t := Timer.new()
	t.one_shot = true
	parent.add_child(t)
	t.timeout.connect(callback)
	return t


func _stop_and_free(t: Timer) -> void:
	if t == null:
		return
	t.stop()
	t.queue_free()

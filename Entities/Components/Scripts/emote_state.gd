class_name EmoteState
extends State

@export var stand_state: StandState
@export var animation_prefix: String = "Emote"
@export var is_loopable: bool = false


var emote_id: int = 0
var duration: float = 0.0
var timer: float = 0.0
var is_playing: bool = false


func enter() -> void:
	if emote_id > 0:
		var anim_name := "%s%d" % [animation_prefix, emote_id]
		entity.animator.set_animation(anim_name, float(entity.facing))
	else:
		push_warning("EmoteState.enter() called without valid emote_id")


func exit() -> void:
	is_playing = false
	emote_id = 0
	timer = 0.0
	duration = 0.0


func process_physics(delta: float) -> State:
	if not is_playing:
		is_playing = true
		duration = _get_animation_length()
		timer = 0.0
		
		if is_loopable:
			var mult: int = [3, 4, 5, 6].pick_random()
			duration *= mult
	
	timer += delta
	if timer >= duration:
		return stand_state
	
	entity.velocity.y += gravity * delta
	entity.move_and_slide()
	return null


func _get_animation_length() -> float:
	var anim_name := ("%s%d" % [animation_prefix, emote_id]).to_lower()
	if entity.animator.animation_player.has_animation(anim_name):
		return entity.animator.animation_player.get_animation(anim_name).length
	return 1.0

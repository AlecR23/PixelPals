class_name Grass
extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state_machine = animation_tree.get("parameters/playback")
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var background: Node2D

@export var flattened_min: float = 0.5
@export var flattened_max: float = 2.0

const GRASS  = preload("uid://dqdd1s0nh53le")
const GRASS_2 = preload("uid://p3ccth2od4i0")
const GRASS_3 = preload("uid://ch78uqa1gygxg")
const GRASS_4 = preload("uid://3ftj66cuarme")
const GRASS_5 = preload("uid://vsfeklo7n5cl")

var grow_timer: SceneTreeTimer = null
var bodies_inside: int = 0


func _ready() -> void:
	_apply_random_grass_texture()


func _process(_delta: float) -> void:
	monitoring = background.visible


func _apply_random_grass_texture() -> void:
	var options: Array = [GRASS, GRASS_2, GRASS_3, GRASS_4, GRASS_5]
	var pick = options[randi() % options.size()]
	
	sprite_2d.texture = pick


func set_animation(new_animation: String, direction: float) -> void:
	var path: String = "parameters/" + new_animation + "/blend_position"
	
	animation_tree.set(path, direction)
	animation_state_machine.travel(new_animation)


func _on_body_entered(_body: Node) -> void:
	bodies_inside += 1
	
	if grow_timer != null:
		if grow_timer.timeout.is_connected(_on_grow_timeout):
			grow_timer.timeout.disconnect(_on_grow_timeout)
		grow_timer = null
	
	set_animation("flatten", 0)


func _on_body_exited(_body: Node) -> void:
	bodies_inside = max(0, bodies_inside - 1)
	
	if bodies_inside > 0:
		return
	
	var delay := randf_range(flattened_min, flattened_max)
	grow_timer = get_tree().create_timer(delay)
	grow_timer.timeout.connect(_on_grow_timeout)


func _on_grow_timeout() -> void:
	grow_timer = null
	set_animation("grow", 0)


func _on_grow_finished() -> void:
	set_animation("grown", 0)

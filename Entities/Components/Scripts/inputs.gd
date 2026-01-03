class_name Inputs
extends Node

@export var entity: Entity
@export var active: bool = true
@export var _driver: InputsDriver

var input_left: bool = false
var input_right: bool = false
var input_direction: int = 0
var input_run: bool = false
var face_front: bool = false
var emote_key: int = 0
var input_locked: bool = false


func _ready() -> void:
	set_physics_process(active)


func set_driver(new_driver: InputsDriver) -> void:
	if _driver:
		_driver.exit(entity, self)
	
	_driver = new_driver
	
	clear()
	if _driver and active:
		_driver.enter(entity, self)


func set_active(value: bool) -> void:
	if active == value:
		return
	active = value
	set_physics_process(active)
	
	if not active:
		if _driver:
			_driver.exit(entity, self)
		clear()
	else:
		if _driver:
			_driver.enter(entity, self)


func _physics_process(delta: float) -> void:
	if not active or _driver == null:
		return
	
	face_front = false
	emote_key = 0

	_driver.physics_update(entity, self, delta)


func _unhandled_input(event: InputEvent) -> void:
	if not active or _driver == null:
		return
	_driver.handle_input(entity, self, event)


func clear() -> void:
	input_left = false
	input_right = false
	input_direction = 0
	input_run = false
	face_front = false
	emote_key = 0
	input_locked = false

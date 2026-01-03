class_name ControlsIcon
extends Icon

@onready var sprite_2d = $Sprite2D

const CONTROLS_HOVERED_ICON = preload("uid://b8m5aobgjnipi")
const CONTROLS_ICON = preload("uid://dnasagrs3suy2")
const CONTROLS_PRESSED_ICON = preload("uid://drurnpb62svsj")

const CONTROLS_ACTIVE_HOVERED_ICON = preload("uid://cryv8twscbjd3")
const CONTROLS_ACTIVE_ICON = preload("uid://bmlhaviqypxpo")
const CONTROLS_ACTIVE_PRESSED_ICON = preload("uid://cwejmyjgtj6ef")

var controls_open: bool = false


func _ready() -> void:
	sprite_2d.visible = false
	_apply_visuals()


func _pressed() -> void:
	_toggle_controls_open()


func _toggle_controls_open() -> void:
	controls_open = !controls_open
	_apply_visuals()


func _apply_visuals() -> void:
	if controls_open:
		_update_sprites(
			CONTROLS_ACTIVE_HOVERED_ICON,
			CONTROLS_ACTIVE_ICON,
			CONTROLS_ACTIVE_PRESSED_ICON
		)
		sprite_2d.visible = true
	else:
		_update_sprites(
			CONTROLS_HOVERED_ICON,
			CONTROLS_ICON,
			CONTROLS_PRESSED_ICON
		)
		sprite_2d.visible = false


func _update_sprites(hovered_icon: Texture2D, icon: Texture2D, pressed_icon: Texture2D) -> void:
	texture_normal = icon
	texture_hover = hovered_icon
	texture_pressed = pressed_icon

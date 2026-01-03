class_name KeepFrontIcon
extends Icon

const KEEP_FRONT_FALSE_HOVERED_ICON = preload("uid://dk2teibxow8oc")
const KEEP_FRONT_FALSE_ICON = preload("uid://83ipaw0bmueh")
const KEEP_FRONT_FALSE_PRESSED_ICON = preload("uid://bwa1or6fsdpj0")

const KEEP_FRONT_TRUE_HOVERED_ICON = preload("uid://cpfudrygsyqlr")
const KEEP_FRONT_TRUE_ICON = preload("uid://c8j832bxoufne")
const KEEP_FRONT_TRUE_PRESSED_ICON = preload("uid://dntw23ot5gc12")

var on_top: bool = true


func _ready() -> void:
	on_top = Settings.always_on_top
	get_window().always_on_top = on_top
	_apply_visuals()


func _pressed() -> void:
	_toggle_on_top()


func _toggle_on_top() -> void:
	on_top = !on_top
	get_window().always_on_top = on_top
	Settings.always_on_top = on_top
	Settings.save_settings()
	_apply_visuals()


func _apply_visuals() -> void:
	if on_top:
		_update_sprites(
			KEEP_FRONT_TRUE_HOVERED_ICON,
			KEEP_FRONT_TRUE_ICON,
			KEEP_FRONT_TRUE_PRESSED_ICON
		)
	else:
		_update_sprites(
			KEEP_FRONT_FALSE_HOVERED_ICON,
			KEEP_FRONT_FALSE_ICON,
			KEEP_FRONT_FALSE_PRESSED_ICON
		)


func _update_sprites(hovered_icon: Texture2D, icon: Texture2D, pressed_icon: Texture2D) -> void:
	texture_normal = icon
	texture_hover = hovered_icon
	texture_pressed = pressed_icon

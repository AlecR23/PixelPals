class_name WindowSizeIcon
extends Icon

const SETTINGS_PATH := "user://settings.cfg"
const SETTINGS_SECTION := "window"
const SETTINGS_KEY := "size_mode"

const WINDOW_SIZE_DEFAULT_HOVERED_ICON = preload("uid://cmtvo0btljilm")
const WINDOW_SIZE_DEFAULT_ICON = preload("uid://dbbkxr5hvrnkr")
const WINDOW_SIZE_DEFAULT_PRESSED_ICON = preload("uid://bd0c7tgjbosd7")

const WINDOW_SIZE_LARGE_HOVERED_ICON = preload("uid://dpxnbpsoknw8l")
const WINDOW_SIZE_LARGE_ICON = preload("uid://bklhewwba4c2")
const WINDOW_SIZE_LARGE_PRESSED_ICON = preload("uid://cpwi0tl1c7nv4")

const WINDOW_SIZE_SMALL_HOVERED_ICON = preload("uid://dbwggitpbkuar")
const WINDOW_SIZE_SMALL_ICON = preload("uid://wyh58fi67ut4")
const WINDOW_SIZE_SMALL_PRESSED_ICON = preload("uid://wptfg2qo4pd4")

const WINDOW_SIZE_XLARGE_HOVERED_ICON = preload("uid://bwxmk8rbg0xvx")
const WINDOW_SIZE_XLARGE_ICON = preload("uid://bbkcdfwgxs85k")
const WINDOW_SIZE_XLARGE_PRESSED_ICON = preload("uid://bwcspiwi2fbv")

const SIZE_SMALL := Vector2i(240, 160)
const SIZE_DEFAULT := Vector2i(480, 320)
const SIZE_LARGE := Vector2i(720, 480)
const SIZE_XLARGE := Vector2i(960, 640)

enum WindowSizeMode { SMALL, DEFAULT, LARGE, XLARGE }
var mode: WindowSizeMode = WindowSizeMode.DEFAULT


func _ready() -> void:
	_load_mode()
	_apply_visuals()
	_apply_window_size()


func _pressed() -> void:
	_cycle_mode()


func _cycle_mode() -> void:
	mode = ((mode + 1) % WindowSizeMode.size()) as WindowSizeMode
	_save_mode()
	_apply_visuals()
	_apply_window_size()


func _apply_window_size() -> void:
	var target := SIZE_DEFAULT
	match mode:
		WindowSizeMode.SMALL:  target = SIZE_SMALL
		WindowSizeMode.DEFAULT: target = SIZE_DEFAULT
		WindowSizeMode.LARGE:  target = SIZE_LARGE
		WindowSizeMode.XLARGE: target = SIZE_XLARGE

	get_window().size = target


func _apply_visuals() -> void:
	match mode:
		WindowSizeMode.SMALL:
			_update_sprites(WINDOW_SIZE_SMALL_HOVERED_ICON, WINDOW_SIZE_SMALL_ICON, WINDOW_SIZE_SMALL_PRESSED_ICON)
		WindowSizeMode.DEFAULT:
			_update_sprites(WINDOW_SIZE_DEFAULT_HOVERED_ICON, WINDOW_SIZE_DEFAULT_ICON, WINDOW_SIZE_DEFAULT_PRESSED_ICON)
		WindowSizeMode.LARGE:
			_update_sprites(WINDOW_SIZE_LARGE_HOVERED_ICON, WINDOW_SIZE_LARGE_ICON, WINDOW_SIZE_LARGE_PRESSED_ICON)
		WindowSizeMode.XLARGE:
			_update_sprites(WINDOW_SIZE_XLARGE_HOVERED_ICON, WINDOW_SIZE_XLARGE_ICON, WINDOW_SIZE_XLARGE_PRESSED_ICON)


func _update_sprites(hovered_icon: Texture2D, icon: Texture2D, pressed_icon: Texture2D) -> void:
	texture_normal = icon
	texture_hover = hovered_icon
	texture_pressed = pressed_icon


func _load_mode() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SETTINGS_PATH) != OK:
		return
	
	var raw := int(cfg.get_value(SETTINGS_SECTION, SETTINGS_KEY, int(mode)))
	# Clamp in case you add/remove enum entries later
	raw = clamp(raw, 0, WindowSizeMode.size() - 1)
	mode = raw as WindowSizeMode


func _save_mode() -> void:
	var cfg := ConfigFile.new()
	cfg.load(SETTINGS_PATH) # OK if it fails; we'll overwrite on save
	cfg.set_value(SETTINGS_SECTION, SETTINGS_KEY, int(mode))
	cfg.save(SETTINGS_PATH)

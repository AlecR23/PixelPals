class_name BackgroundIcon
extends Icon

const SETTINGS_PATH := "user://settings.cfg"
const SETTINGS_SECTION := "ui"
const SETTINGS_KEY := "background_name"

@onready var entities = $"../../../../../../../World/Entities"
@onready var selector_texture_rect = $"../../SelectorTextureRect"

@export var active_background: Node2D
@export var inactive_backgrounds: Array[Node2D]


func _ready() -> void:
	_apply_saved_background_if_match()


func _pressed() -> void:
	_apply_background(active_background)
	_save_background(active_background.name)
	_startle_entities()


func _apply_background(bg: Node2D) -> void:
	for background in inactive_backgrounds:
		background.visible = false
	bg.visible = true


func _save_background(bg_name: String) -> void:
	var cfg := ConfigFile.new()
	cfg.load(SETTINGS_PATH) # OK if it fails
	cfg.set_value(SETTINGS_SECTION, SETTINGS_KEY, bg_name)
	cfg.save(SETTINGS_PATH)


func _startle_entities():
	for entity in entities.get_children():
		entity.is_startled = true


func _apply_saved_background_if_match() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SETTINGS_PATH) != OK:
		return
	
	var saved_name := String(cfg.get_value(SETTINGS_SECTION, SETTINGS_KEY, ""))
	if saved_name == "":
		return
	
	if active_background != null and active_background.name == saved_name:
		_apply_background(active_background)

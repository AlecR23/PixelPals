extends Node

const PATH := "user://settings.cfg"

var _cfg := ConfigFile.new()

var always_on_top: bool = false


func _ready() -> void:
	randomize()
	load_settings()


func load_settings() -> void:
	var err := _cfg.load(PATH)
	if err != OK:
		return
	
	always_on_top = _cfg.get_value("window", "always_on_top", always_on_top)


func save_settings() -> void:
	_cfg.set_value("window", "always_on_top", always_on_top)
	_cfg.save(PATH)

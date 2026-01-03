class_name HangingEscButton
extends TextureButton

@onready var selector_texture_rect = $".."


func _pressed():
	selector_texture_rect._toggle_pause()

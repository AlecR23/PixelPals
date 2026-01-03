class_name EscButton
extends TextureButton

@onready var selector_texture_rect = $".."


func _pressed():
	selector_texture_rect._toggle_pause()

class_name RightArrow
extends TextureButton

@onready var selector_texture_rect = $".."


func _pressed():
	selector_texture_rect.iterate_current_selection(1)

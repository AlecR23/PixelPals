class_name StartButton
extends TextureButton

const MAIN_SCENE: String = "res://Levels/main.tscn"


func _on_pressed():
	get_tree().change_scene_to_file(MAIN_SCENE)

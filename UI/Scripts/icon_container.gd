class_name IconContainer
extends GridContainer

@export var player_icons: Array[PlayerIcon]
@export var background_icons: Array[Icon]
@export var options_icons: Array[Icon]


enum selection{
	PLAYER,
	BACKGROUND,
	OPTIONS
}


func display_icons(screen):
	match screen:
		selection.PLAYER:
			_display_icons(player_icons)
		selection.BACKGROUND:
			_display_icons(background_icons)
		selection.OPTIONS:
			_display_icons(options_icons)


func hide_icons():
	for icon in player_icons:
		icon.visible = false
	for icon in background_icons:
		icon.visible = false
	for icon in options_icons:
		icon.visible = false


func _display_icons(group):
	var reveal_delay: float = 0.05
	if group.size == null:
		return
	
	for icon in group:
		icon.visible = true
		await get_tree().create_timer(reveal_delay).timeout

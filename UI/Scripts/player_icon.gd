class_name PlayerIcon
extends Icon

@onready var selector_texture_rect = $"../../SelectorTextureRect"

@export var player: Entity
@export var npcs: Array[Entity]


enum input_sources{
	COMPUTER,
	PLAYER
}


func _pressed():
	for npc in npcs:
		npc.set_input(input_sources.COMPUTER)
	
	if player == null:
		selector_texture_rect._toggle_pause()
		return
	
	player.set_input(input_sources.PLAYER)
	selector_texture_rect._toggle_pause()

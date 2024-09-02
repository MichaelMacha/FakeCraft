## All elements which can be considered to be a controllable part of a faction.
## That is, all buildings, and all units, will extend this.
class_name Entity extends CharacterBody3D

signal request_update_ui

@export var selection_glow : Node3D

# TODO: This should have some one-to-many tie to a faction.

## Whether the entity is selected
@export var selected : bool = false:
	set(value):
		selected = value
		if selection_glow:
			selection_glow.visible = value
		
		request_update_ui.emit()

func _ready() -> void:
	request_update_ui.connect($/root/Map/UI._trigger_update_ui)

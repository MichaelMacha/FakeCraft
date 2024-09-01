## All elements which can be considered to be a controllable part of a faction.
## That is, all buildings, and all units, will extend this.
class_name Entity extends Node

@export var selection_glow : Node3D

# TODO: This should have some one-to-many tie to a faction.

## Whether the entity is selected
@export var selected : bool = false:
	set(value):
		selected = value
		if selection_glow:
			selection_glow.visible = value
		#print("Selected: ", selected)

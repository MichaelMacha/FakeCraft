## Base manager for all game activity that requires global properties or
## global operations, but isn't specific enough for anything else. Autoload.

extends Node

##Enum of all unit types in the game
enum UnitType {
	GENERIC_UNIT
}

##List of all unit types in order of selection priority (for things like 
##determining the appropriate unit UI, and so on.
var unit_priority : Array = [UnitType.GENERIC_UNIT]

const button_order := \
	[ControlButton.ButtonLocation.TOP_LEFT,
	ControlButton.ButtonLocation.TOP,
	ControlButton.ButtonLocation.TOP_RIGHT,
	ControlButton.ButtonLocation.LEFT,
	ControlButton.ButtonLocation.CENTER,
	ControlButton.ButtonLocation.RIGHT,
	ControlButton.ButtonLocation.BOTTOM_LEFT,
	ControlButton.ButtonLocation.BOTTOM,
	ControlButton.ButtonLocation.BOTTOM_RIGHT]

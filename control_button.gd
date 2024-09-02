class_name ControlButton extends Node

enum ButtonLocation {
	TOP_LEFT,
	TOP,
	TOP_RIGHT,
	LEFT,
	CENTER,
	RIGHT,
	BOTTOM_LEFT,
	BOTTOM,
	BOTTOM_RIGHT
}

@export var button_location : ButtonLocation = ButtonLocation.TOP_LEFT
@export var graphic : Texture2D
@export var action : Callable

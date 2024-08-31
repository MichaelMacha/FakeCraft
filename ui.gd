extends Control

var start_box_pos : Vector2
var dragging : bool = false

@onready var hud: PanelContainer = $HUD

func _input(event: InputEvent) -> void:
	#Check for efforts at box selection
	if event.is_action("select"):
		if over_playfield():
			if event.pressed:
				if not dragging:
					start_box_pos = get_viewport().get_mouse_position()
				dragging = true
		if event.is_released():
			dragging = false

func _process(delta: float) -> void:
	
	# Call a _draw, since this must be done manually
	queue_redraw()

## Draw custom graphics like our box selector
func _draw() -> void:
	if dragging:
		draw_rect(Rect2(start_box_pos, get_global_mouse_position() - start_box_pos),
			Color.GREEN, false, 2.0)

## Determine whether the mouse is over the playfield, or over the UI.
##
## Returns true when over the playfield.
func over_playfield() -> bool:
	return not hud.get_rect().has_point(get_global_mouse_position())

class_name UI extends Control
#
##I am doing this entirely wrong.
#
##New Method: On select down, sample the start point in world space by shooting
##from the camera. Do the same on select up, for the end point. Use these two
##points to calculate a world-space rect to compare against, and check it against
##the XZ coordinates of units to see if they're selected.
#

const RAY_LENGTH = 1000.0

@onready var hud: PanelContainer = $HUD
@onready var map : Node3D = $".."
@onready var camera_3d: Camera3D = $"../Global/Camera3D"
@onready var space_state := map.get_world_3d().direct_space_state
@onready var units: Node3D = $"../Units"

##Start of our drag box in world space
var rect_start : Vector3 = -Vector3.INF

##End of our drag box in world space
var rect_end : Vector3 = -Vector3.INF

##Whether we're currently dragging a box
var dragging := false:
	set(value):
		dragging = value
		#This is interfering with our click control. Find a way to support both.
		if not dragging:
			check_selection()

func _unhandled_input(event: InputEvent) -> void:
#func _input(event: InputEvent) -> void:
	if event.is_action("select"):
		if over_playfield():
			if event.pressed:
				start_drag(event.position)
			else:
				end_drag(event.position)
		else:
			end_drag(event.position)

func start_drag(pos : Vector2) -> void:
	rect_start = query_world_position(pos)
	#print("Rect Start: ", rect_start)
	dragging = true

func end_drag(pos: Vector2) -> void:
	rect_end = query_world_position(pos)
	dragging = false
	#print("Rect End: ", rect_end)

## Old Stuff
#
#
#
#
#var start_box_pos : Vector2
#var start_box_world_pos : Vector3
#
#
#var dragging : bool = false:
	#set(value):
		#dragging = value
		#if not dragging:
			##Here we implement the behavior associated with dragging a box, as
			##we have all of the data necessary—that is, the current mouse
			##position, the start mouse position, and presumably access to all
			##of the units.
			#
			##Project a frustrum through the box.
			##Iterate over all units
				##(which can't be ruled out by other means)
				##See if they intersect the frustrum at all
			#
			##TODO: Godot does not have a Frustrum3D shape, but this might be
			##something to come back to with an extension.
			#
			## Starcraft was a '98-ish game; let's go with a Rect2 check.
			#var start := Vector2(start_box_world_pos.x, start_box_world_pos.z)
			#var world_pos = query_world_position(get_global_mouse_position())
			#var end := Vector2(world_pos.x, world_pos.z) - start
			#var rect := Rect2(
				#start,
				#end
			#).abs()
			#
			#for unit in $"../Units".get_children():
				#print("Unit: ", unit)
				#
				## Assume unit is an entity
				#var entity : Entity = unit
				#var point := Vector2(unit.global_position.x, unit.global_position.z)
				#print("Rect ", rect, " has point ", point, ": ", rect.has_point(point))
				#entity.selected = rect.has_point(point)
				#
			#print(rect)
#

#
func query_world_position(screen_position : Vector2) -> Vector3:
	var from := camera_3d.project_ray_origin(screen_position)
	var to := from + camera_3d.project_ray_normal(screen_position) * RAY_LENGTH
	var query := PhysicsRayQueryParameters3D.create(from, to)
	var result : Dictionary = space_state.intersect_ray(query)
	
	#Assumption: We have a WorldBoundary collider at the Y = 0 plane, and we
	#will always have collided with something. Therefore this is valid:
	
	return result.position

func query_screen_position(world_position : Vector3) -> Vector2:
	return camera_3d.unproject_position(world_position)

func _process(delta: float) -> void:
	# Call a _draw, since this must be done manually
	queue_redraw()

### Draw custom graphics like our box selector
func _draw() -> void:
	if dragging:
		#var new_origin := camera_3d.unproject_position(start_box_world_pos)
		var new_origin := query_screen_position(rect_start)
		draw_rect(
			Rect2(new_origin, get_global_mouse_position() - new_origin),
				Color.GREEN, false, 2.0
			)
#
### Determine whether the mouse is over the playfield, or over the UI.
###
### Returns true when over the playfield.
func over_playfield() -> bool:
	#Basically just ignore the HUD space
	return not hud.get_rect().has_point(get_global_mouse_position())

## Iterate over all units qualified for selection, and see if their XZ 
## coordinate falls between rect_start and rect_end

func check_selection() -> void:
	var rect := Rect2(
		Vector2(rect_start.x, rect_start.z), 
		Vector2(rect_end.x, rect_end.z)) #.abs()
	for unit in units.get_children():
		var location := Vector2(unit.global_position.x,
		unit.global_position.z)
		unit.selected = rect.has_point(location)

func select(entity : Entity) -> void:
	for unit in units.get_children():
		unit.selected = false
	
	entity.selected = true

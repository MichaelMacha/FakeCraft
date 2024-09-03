class_name UI extends Control

# New Method (Contract): We need to check for a click, and then handle a drag
# if the qualifiers for a click aren't met. 

@export var click_time : float = 0.25

@export_category("Internal")
enum SelectState {
	CLICK,
	DRAG
}
@export var state : SelectState = SelectState.CLICK

const RAY_LENGTH = 1000.0

@onready var hud: PanelContainer = $HUD
@onready var map : Node3D = $".."
@onready var camera_3d: Camera3D = $"../Global/Camera3D"
@onready var space_state := map.get_world_3d().direct_space_state
@onready var units: Node3D = $"../Units"
@onready var buttons: GridContainer = $HUD/HBoxContainer/Options

var mouse_down_time : float
var drag_start : Vector3
var drag_end : Vector3

func _physics_process(_delta: float) -> void:
	if update_frame == Engine.get_process_frames():
		print("Update UI")
		update_ui()

func _process(_delta: float) -> void:
	queue_redraw()

func _input(event: InputEvent) -> void:
	var seconds = Time.get_ticks_msec()/1000.0
	
	match state:
		SelectState.CLICK:
			if event.is_action("select") and event.pressed:
				#First check for a click.
				var result = pick(event.position)
				
				#Assume we always hit something, as we have a WorldBoundary as a floor, and can't tilt the camera up enough to expose the sky.
				drag_start = result.position
				mouse_down_time = seconds
				
				#After click is handled, assume a drag.
				state = SelectState.DRAG
			elif event.is_action("act") and event.pressed:
				#Get each selected unit
				for unit in units.get_children() \
					.filter(func(unit): return unit.selected):
					var loc = pick(event.position)
					if not loc.is_empty():
						unit.right_behavior.handle_input(event, loc.position)
		SelectState.DRAG:
			if event.is_action("select") and not event.pressed:
				var result = pick(event.position)
				
				drag_end = result.position
				
				if seconds - mouse_down_time < click_time and \
					result.collider is Entity:
					#TODO: qualify entity (make sure it can be selected) first
					
					if Input.is_action_pressed("append"):
						append([result.collider])
					else:
						select([result.collider])
					#result.collider.selected = true
				else:
					var box : AABB = AABB(drag_start, drag_end - drag_start).abs()
					box = box.grow(0.5) # Grow enough to avoid missing the Z
					
					var selected : Array = []
					for unit in units.get_children():
						if box.has_point(unit.global_position):
							selected.append(unit)
					
					if not selected.is_empty():
						if Input.is_action_pressed("append"):
							append(selected)
						else:
							select(selected)
				
				state = SelectState.CLICK

## Append onto the selected units
func append(entities: Array) -> void:
	for entity in units.get_children():
		if entities.has(entity):
			entity.selected = true

## Select a new group of units, deselecting the old
func select(entities : Array) -> void:
	for entity in units.get_children():
		entity.selected = entities.has(entity)

func pick(point : Vector2) -> Dictionary:
	var ray_origin = camera_3d.project_ray_origin(point)
	var ray_target = ray_origin + camera_3d.project_ray_normal(point) * RAY_LENGTH
	
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_target)
	return space_state.intersect_ray(query)	

func unpick(world_position : Vector3) -> Vector2:
	return camera_3d.unproject_position(world_position)

func _draw() -> void:
	if state == SelectState.DRAG:
		#var new_origin := camera_3d.unproject_position(start_box_world_pos)
		var new_origin := unpick(drag_start)
		draw_rect(
			Rect2(new_origin, get_global_mouse_position() - new_origin),
				Color.GREEN, false, 2.0
			)

var update_frame := 0

## Receives signal triggering a UI update. The actual update happens in
## _physics_process, as this is frequently emitted by every unit and to
## do it here would be needlessly expensive.
func _trigger_update_ui() -> void:
	update_frame = Engine.get_process_frames()

#TODO: Unit test with second unit
func update_ui() -> void:
	# Called at most once per physics frame, by design
	
	# Here, we need to get the unit type which is of highest priority with a
	# basic sort
	
	var entity : Entity = get_selection_priority()
	
	if entity:
		# We make certain enforced assumptions about entities.
		# They should all have a Controls child node, which contains a list
		# of ControlButtons.
		assert(entity.has_node("Controls"))
		
		var controls := entity.get_node("Controls")
		
		#Iterate over all locations
		#	Find matching control button and place its graphic
		#	Associate a lambda from ControlButton with the button press
		
		var find_control := func(location : ControlButton.ButtonLocation) -> ControlButton:
			var acceptable : Array = \
				controls.get_children().filter(
					func(control): return control.button_location == location
					)
			
			if not acceptable.is_empty():
				return acceptable.front()
			return null
		
		var disconnect_all := func(sig : Signal):
			for item in sig.get_connections():
				sig.disconnect(item.callable)
		
		for index in buttons.get_child_count():
			print("Index: ", index)
			var button_loc : ControlButton.ButtonLocation = \
				ControlButton.ButtonLocation.values()[index]
			var button : Button = buttons.get_child(index)
			var control : ControlButton = find_control.call(button_loc)
			
			if control:
				button.icon = control.graphic
				button.text = ""
				#TODO: connect button.pressed to control lambda
				disconnect_all.call(button.pressed)
				button.pressed.connect(control.action)
			else:
				button.icon = null
				button.text = ""
				
				#Disconnect all associated actions
				disconnect_all.call(button.pressed)
		
	

func get_selection_priority() -> Entity:
	var selected : Array = units.get_children() \
		.filter(func(child): return child.selected)
	selected.sort_custom(
			func(child1, child2):
				var priority1 = Manager.unit_priority.find(child1)
				var priority2 = Manager.unit_priority.find(child2)
				return priority1 > priority2
				)
	
	#NOTE: Should this be .front()?
	if not selected.is_empty():
		return selected.back()
	else:
		return null

func selected_units() -> Array:
	var selected := []
	for unit in units.get_children():
		if unit.selected:
			selected.append(unit)
	return selected

class_name Mouse extends Node3D

@onready var map : Node3D = $".."
@onready var camera_3d: Camera3D = $"../Global/Camera3D"
@onready var space_state := map.get_world_3d().direct_space_state

const RAY_LENGTH = 1000.0

@onready var current_cursor : MouseCursor = $MouseCursor

func switch_cursor(cursor : MouseCursor) -> void:
	#Set current cursor
	current_cursor = cursor
	
	#Show this visually
	for child in get_children():
		child.visible = false
	cursor.visible = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		var origin := camera_3d.project_ray_origin(event.position)
		var target := origin + camera_3d.project_ray_normal(event.position) * RAY_LENGTH
		
		if event is InputEventMouseMotion:
			#Only intersect floor here, which is on Physics3D layer 2.
			var query := PhysicsRayQueryParameters3D.create(origin, target, 2)
			var result := space_state.intersect_ray(query)
			
			if not result.is_empty():
				self.global_position = result.position 
			#ray cast to position
		elif event.is_action("select"):
			#Intersect both floor and unit, as discriminating is important
			var query := PhysicsRayQueryParameters3D.create(origin, target)
			var result := space_state.intersect_ray(query)
			
			if not result.is_empty():
				current_cursor.handle_input(event, result)

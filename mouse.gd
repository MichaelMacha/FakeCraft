class_name Mouse extends Node3D

@onready var map : Node3D = $".."
@onready var camera_3d: Camera3D = $"../Global/Camera3D"
@onready var space_state := map.get_world_3d().direct_space_state

const RAY_LENGTH = 1000.0

@onready var current_behavior : MouseBehavior = $MouseBehavior

func switch_behavior(behavior : MouseBehavior) -> void:
	#Set current behavior
	current_behavior = behavior
	
	#Show this visually
	for child in get_children():
		child.visible = false
	behavior.visible = true

func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		var origin := camera_3d.project_ray_origin(event.position)
		var target := origin + camera_3d.project_ray_normal(event.position) * RAY_LENGTH
		
		#Only intersect floor, which is on Physics3D layer 2.
		var query := PhysicsRayQueryParameters3D.create(origin, target, 2)
		var result := space_state.intersect_ray(query)
		
		if event is InputEventMouseMotion:
			if not result.is_empty():
				self.global_position = result.position 
			#ray cast to position
		elif event.is_action("select"):
			if not result.is_empty():
				current_behavior.handle_input(event, result.position)

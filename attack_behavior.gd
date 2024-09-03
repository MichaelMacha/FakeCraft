class_name AttackCursor extends MouseCursor

@onready var ui: UI = $"../../UI"
@onready var space_state := self.get_world_3d().direct_space_state
@onready var camera_3d: Camera3D = $"../../Global/Camera3D"

func handle_input(event : InputEvent, result : Dictionary) -> void:
	#Do universals
	super.handle_input(event, result)
	
	var projection = result.position
	
	#Act
	#Get unit fired upon
	if result.collider is Unit:
		print("Attacking Unit")
		#TODO: Later, the unit will be moving; ensure that we're consistently
		#updating our target point to follow it
	else:
		print("Attacking Ground")
		#We're just arming up and approaching the patch of ground, returning
		#fire as we go.
	
	
	#TODO: Trigger attacking for unit until it reaches destination
	for unit in ui.selected_home_units():
		if Input.is_action_pressed("append"):
			unit.enqueue(projection)
		else:
			unit.go(projection)
	
	$"..".switch_cursor($"../MouseCursor")

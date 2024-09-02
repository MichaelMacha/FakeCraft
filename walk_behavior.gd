class_name WalkBehavior extends MouseBehavior

@onready var ui: UI = $"../../UI"

func handle_input(event : InputEvent, projection : Vector3) -> void:
	#Do universals
	#TODO: See if we even need this in GDScript, it may be a default.
	super.handle_input(event, projection)
	
	#Act
	for unit in ui.selected_units():
		if Input.is_action_pressed("append"):
			unit.enqueue(projection)
		else:
			unit.go(projection)
		
	print(ui.selected_units())
	
	$"..".switch_behavior($"../MouseBehavior")

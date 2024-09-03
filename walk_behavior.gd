class_name WalkBehavior extends MouseBehavior

@onready var ui: UI = $"../../UI"

func handle_input(event : InputEvent, projection : Vector3) -> void:
	#Do universals
	super.handle_input(event, projection)
	
	#Act
	for unit in ui.selected_home_units():
		if Input.is_action_pressed("append"):
			unit.enqueue(projection)
		else:
			unit.go(projection)
		
	$"..".switch_behavior($"../MouseBehavior")

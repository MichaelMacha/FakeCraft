class_name WalkCursor extends MouseCursor

@onready var ui: UI = $"../../UI"

func handle_input(event : InputEvent, result : Dictionary) -> void:
	#Do universals
	super.handle_input(event, result)
	
	var projection = result.position
	
	#Act
	for unit in ui.selected_home_units():
		if Input.is_action_pressed("append"):
			unit.enqueue(projection)
		else:
			unit.go(projection)
		
	$"..".switch_cursor($"../MouseCursor")

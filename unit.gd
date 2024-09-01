class_name Unit extends Entity

@onready var ui : UI = $"/root/Map/UI"

func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#print("Clicked on ", self)
	pass

func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	#Almost works, but cancels out from UI. Better we handle it there.
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#if event.pressed:
				#ui.select(self)
				#get_viewport().set_input_as_handled()
			#
	pass

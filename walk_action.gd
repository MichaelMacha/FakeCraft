class_name WalkAction extends ControlButton

@onready var unit: Unit = $"../.."

func _ready() -> void:
	## Set the current action to walk. Walk behavior should alter the mouse
	## cursor, then set the unit's target to whatever point is left-clicked on.
	self.action = func():
		
		pass

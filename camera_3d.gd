extends Camera3D

@export var speed := 1.0
@export var control_bounds := 0.1

@onready var ui: Control = $"../../UI"

var go_west := false
var go_east := false
var go_north := false
var go_south := false

func get_mouse_ratio() -> Vector2:
	var viewport := self.get_viewport()
	var pos = viewport.get_mouse_position()
	pos.x /= viewport.size.x
	pos.y /= viewport.size.y
	return pos

func _physics_process(delta: float) -> void:
	var axis := Input.get_vector("west", "east", "north", "south")
	
	var ratio := get_mouse_ratio()
	
	var d : float
	if ratio.x > 0.0 and ratio.x < 1.0 and ratio.y > 0.0 and ratio.y < 1.0:
		if ratio.x < control_bounds:
			d = (control_bounds - ratio.x)/control_bounds
			axis.x = lerp(0.0, -1.0, d)
		if ratio.x > 1.0 - control_bounds:
			d = (ratio.x - (1.0 - control_bounds))/control_bounds
			axis.x = lerp(0.0, 1.0, d)
		if ratio.y < control_bounds:
			d = (control_bounds - ratio.y)/control_bounds
			axis.y = lerp(0.0, -1.0, d)
		if ratio.y > 1.0 - control_bounds:
			d = (ratio.y - (1.0 - control_bounds))/control_bounds
			axis.y = lerp(0.0, 1.0, d)
	
	self.position += Vector3(axis.x, 0.0, axis.y) * speed * delta

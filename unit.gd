## Default unit. /TOO default/, shouldn't show up in actual gameplay, but,
## core of all tests on units.

class_name Unit extends Entity

@onready var navagent: NavigationAgent3D = $NavigationAgent3D

## Speed of movement along navigation path
@export var movement_speed := 4.0

## Distance to target which is considered arrival
@export var critical_distance := 0.5

@export_category("Identification")

## Identifies the unit type to the game manager
@export var unit_type : Manager.UnitType = Manager.UnitType.GENERIC_UNIT

var move_queue : Array[Vector3] \
	#Debug list:
	= [Vector3(12.0, 0.0, 12.0), Vector3(12.0, 0.0, -12.0), Vector3(0.0, 0.0, 0.0)]


@onready var ui : UI = $"/root/Map/UI"


## Enqueues a point onto the move queue, as an additional destination.
func enqueue(point : Vector3) -> void:
	move_queue.push_back(point)

## Dequeues the next movement point from the move queue. Assumes that such
## a point exists, so be sure to check.
func dequeue() -> Vector3:
	return move_queue.pop_front()


func _physics_process(delta: float) -> void:
	# Do not query when navigation map is unbaked
	if NavigationServer3D.map_get_iteration_id(navagent.get_navigation_map()) == 0:
		return
	
	if navagent.is_navigation_finished():
		if not move_queue.is_empty():
			navagent.target_position = dequeue()
	else:
		var next_path_position := navagent.get_next_path_position()
		var new_velocity := global_position.direction_to(next_path_position) \
			* movement_speed
		
		if navagent.avoidance_enabled:
			navagent.set_velocity(new_velocity)
		else:
			_on_navigation_agent_3d_velocity_computed(new_velocity)
	
	

func _on_navigation_agent_3d_velocity_computed(safe_velocity: Vector3) -> void:
	velocity = safe_velocity
	move_and_slide()

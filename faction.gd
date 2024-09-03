## Control class for each faction.
##
## All factions have a list of units under their command. They should also have
## a list of conditions which determine whether their mission is a success,
## a failure, or is to-be-determined. This can be retrieved with a field with a
## getter.
##
## A child node should handle the method of control for this faction. This could
## be local controls, a state machine or simulated intelligence (SI) framework,
## or even a network connection. Keep that modular. It may need to adopt some
## of the code from the UI later.

class_name Faction extends Node

## List of buildings and units under Faction's command.
@export var units : Array[Entity]

enum MissionStatus {
	SUCCESS,
	TO_BE_DETERMINED,
	FAILURE
}

## Preconditions for success; if any of these return false, mission is failed
var preconditions : Array[Callable] = [func(): return units.size() > 0]

## Conditions for victory; not having these return true means that victory is
## still TBD; but if they all return true, mission is a success
var conditions : Array[Callable] = [func(): return false]
# NOTE: func(): return false simply is there to ensure that we can test the
# game before this is fully implemented.

var status : MissionStatus = MissionStatus.TO_BE_DETERMINED:
	get():
		if not preconditions.all(func(f): return f.call()):
			return MissionStatus.FAILURE
			
		if conditions.all(func(f): return f.call()):
			return MissionStatus.SUCCESS
		
		return MissionStatus.TO_BE_DETERMINED

func has_entity(entity : Entity) -> bool:
	return (entity in units)

func _ready() -> void:
	print(MissionStatus.keys()[status])

func update_unit_list() -> void:
	for unit in units:
		print(is_instance_valid(unit), " and ", unit.is_inside_tree())
	
	units = units.filter(func(u : Node): return is_instance_valid(u) and u.is_inside_tree())

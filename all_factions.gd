## Manages elements critical to all factions, such as the death of a unit or a
## potential failure/success event

class_name AllFactions extends Node

func remove_entity(entity : Entity):
	for faction in get_children():
		if faction.units.has(entity):
			faction.units.erase(entity)
		
	for faction in get_children():
		#TODO: This should be a call to activate a success/failure overlay
		print(Faction.MissionStatus.keys()[faction.status])

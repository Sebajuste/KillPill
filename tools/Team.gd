extends Node

export var team := ""
export(String, "Blue", "Red", "Yellow") var color
export var max_team = 5

var _team_member_refs := Array()

func get_constructor():
	
	var constructors = get_tree().get_nodes_in_group("constructor")
	for constructor in constructors:
		if constructor.team == self.team:
			return constructor
	return null

func get_team() -> Array:
	var team_list := []
	#for character in get_tree().get_nodes_in_group("character"):
	for character in _team_member_refs:
		if character.get_ref() and character.get_ref().team == self.team:
			team_list.append( character.get_ref() )
	return team_list

func get_next_member(member):
	
	var index = _find_character( member )
	if index != -1:
		
		if _team_member_refs.size() == 1:
			return null
		
		if index == _team_member_refs.size() - 1:
			return _team_member_refs[0].get_ref()
		
		return _team_member_refs[index+1].get_ref()
	return null

func get_previous_member(member):
	var index = _find_character( member )
	if index != -1:
		if _team_member_refs.size() == 1:
			return null
		if index == 0:
			return _team_member_refs[ _team_member_refs.size() - 1].get_ref()
		return _team_member_refs[index-1].get_ref()
	return null

func get_team_ai(only_ai := true) -> Array:
	var team_list := []
	#for character in get_tree().get_nodes_in_group("character"):
	for character_ref in _team_member_refs:
		var character = character_ref.get_ref()
		if character and character.team == self.team and ( not only_ai or character.handler == "AI"):
			team_list.append( character )
	return team_list

func get_ennemies() -> Array:
	var ennemies := []
	var characters = get_tree().get_nodes_in_group("character")
	for character in characters:
		if character.team != self.team:
			ennemies.append( character )
	return ennemies

func get_weapons():
	
	return get_tree().get_nodes_in_group("object_container")
	

func compare_goals(expect: Dictionary, state: Dictionary) -> bool:
	for key in expect:
		if not state.has(key) or state[key] != expect[key]:
			return false
	return true



func _find_character(character) -> int:
	for index in range( _team_member_refs.size() ):
		if _team_member_refs[index].get_ref() == character:
			return index
	return -1


# Called when the node enters the scene tree for the first time.
func _ready():
	
	_update_ai()
	
	var constructor = get_constructor()
	
	constructor.color = color
	#constructor.connect("on_build", self, "_on_constructor_build")
	
	for character in get_tree().get_nodes_in_group("character"):
		if character.team == self.team:
			_team_member_refs.append( weakref(character) )


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_goal(team_member, goal_state):
	
	var goap_planner = team_member.get_node("AIHandler/GoapPlanner")
	
	if not compare_goals(goal_state, goap_planner.goal_state):
		print("[%s - %s] New goal: " % [team, team_member.get_name()], goal_state)
		goap_planner.goal_state = goal_state
		team_member.move_cancel()


func _get_nearest_weapon(actor, weapons: Array, min_distance := 0.0):
	
	var nearest_weapon = null
	var nearest_distance = null
	
	for weapon in weapons:
		var distance = (actor.global_transform.origin - weapon.global_transform.origin).length()
		if (nearest_distance == null or distance < nearest_distance) and distance < min_distance:
			nearest_distance = distance
			nearest_weapon = weapon
	return nearest_weapon


func _update_ai():
	
	if _team_member_refs.empty():
		return
	
	# Analyse situation for team
	
	
	
	# Define object to construct
	
	# If alone,
	#	 create team member
	
	# If more 50% team equiped
	# 	create team member
	# else
	# 	create equipement
	
	
	# Define goal for each team member
	
	var constructor = get_constructor()
	
	var weapons = get_weapons()
	var weapons_count = weapons.size()
	
	var team = get_team_ai()
	
	var team_equiped_count = 0
	
	for team_member in team:
		if team_member.has_object():
			team_equiped_count += 1
	
	var ennemies = get_ennemies()
	
	#
	# Build
	#
	
	constructor.target_pattern_name = ""
	
	if team.size() < max_team / 2:
		constructor.target_pattern_name = "pill"
	elif team.size() - team_equiped_count > weapons_count :
		constructor.target_pattern_name = "gun"
	elif team.size() < max_team - 1:
		constructor.target_pattern_name = "pill"
	
	
	var ready_to_build = constructor.target_ready_to_build()
	
	print("[%s] Construct goal : %s" % [self.team, constructor.target_pattern_name])
	
	
	#
	# Select the nearest team member to build if necessary
	#
	if ready_to_build:
		
		var nearest_index_member = -1
		var nearest_distance = null
		
		var index = 0
		for team_member in team:
			
			var distance = (team_member.global_transform.origin - constructor.global_transform.origin).length()
			
			if nearest_distance == null or distance < nearest_distance:
				nearest_distance = distance
				nearest_index_member = index
			
			index += 1
		
		if nearest_index_member >= 0:
			
			var team_member = team[nearest_index_member]
			
			var goap_planner = team_member.get_node("AIHandler/GoapPlanner")
			
			set_goal(team_member, { "build_done": true })
			var take_boxe_action = goap_planner.get_node("TakeBox")
			if take_boxe_action:
				take_boxe_action.min_distance = 0.0
			
			team.remove(nearest_index_member)
			
		
		
	
	
	#
	# Bring box by default
	#
	for team_member in team:
		
		var goap_planner = team_member.get_node("AIHandler/GoapPlanner")
		
		if constructor.target_pattern_name == "" or constructor.target_ready_to_build():
			set_goal(team_member, { "near_constructor": true, "box_dropped": true})
			var take_boxe_action = goap_planner.get_node("TakeBox") # team_member.get_node("GoapPlanner/TakeBox")
			if take_boxe_action:
				take_boxe_action.min_distance = 10.0
		
		if not team_member.has_object() and weapons_count > 0:
			
			var nearest_weapon = _get_nearest_weapon(team_member, weapons, 10.0)
			
			if nearest_weapon != null:
				set_goal(team_member, { "have_weapon": true })
				weapons_count -= 1
		
	
	#
	# Stack box to build
	#
	if not ready_to_build:
		var nearest_member = null
		var nearest_distance = null
		
		for team_member in team:
			var distance = (team_member.global_transform.origin - constructor.global_transform.origin).length()
			
			if nearest_distance == null or distance < nearest_distance:
				nearest_distance = distance
				nearest_member = team_member
		
		if nearest_member != null:
			var goap_planner = nearest_member.get_node("AIHandler/GoapPlanner")
			set_goal(nearest_member, { "builder_ready": true })
			var take_boxe_action = goap_planner.get_node("TakeBox") #nearest_member.get_node("GoapPlanner/TakeBox")
			if take_boxe_action:
				take_boxe_action.min_distance = 0.0
	
	
	#
	# Agressive
	#
	if _team_member_refs.size() >= max_team - 2 and not ennemies.empty():
		for team_member in team:
			if team_member.has_object():
				set_goal(team_member, { "attack": true })
		return
	
	#
	# Protect constructor
	#
	for ennemy in ennemies:
		
		var constructor_distance = (constructor.global_transform.origin - ennemy.global_transform.origin).length()
		
		if constructor_distance < 15:
			
			for team_member in team:
				
				var team_member_distance = (team_member.global_transform.origin - ennemy.global_transform.origin).length()
				
				if team_member_distance < 20:
					set_goal(team_member, { "attack": true })


func _on_actions_done(team_member):
	
	#_update_ai()
	
	pass

func _on_constructor_build(name, object):
	
	if name == "pill":
		object.connect("on_death", self, "_on_death")
		object.get_node("AIHandler").connect("on_actions_done", self, "_on_actions_done")
		_team_member_refs.push_back( weakref(object) )
	
	_update_ai()
	

func _on_death(object):
	
	var index = _find_character(object)
	if index != -1:
		_team_member_refs.remove(index)
	
	_update_ai()


func _on_constructor_add_box():
	
	_update_ai()
	
	pass # Replace with function body.

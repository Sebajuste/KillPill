extends Node

export var team := ""
export(String, "Blue", "Red") var color
export var max_team = 5



func get_constructor():
	
	var constructors = get_tree().get_nodes_in_group("constructor")
	for constructor in constructors:
		if constructor.team == self.team:
			return constructor
	return null
	

func get_team() -> Array:
	var team_list := []
	var characters = get_tree().get_nodes_in_group("character")
	for character in characters:
		if character.team == self.team and character.ia:
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


# Called when the node enters the scene tree for the first time.
func _ready():
	
	_on_Timer_timeout()
	
	var constructor = get_constructor()
	
	constructor.color = color
	constructor.connect("on_build", self, "_on_build")
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_goal(team_member, goal_state):
	
	if not compare_goals(goal_state, team_member.get_node("GoapPlanner").goal_state):
		print("[%s] New goal: " % team_member.get_name(), goal_state)
		team_member.get_node("GoapPlanner").goal_state = goal_state
		team_member.cancel_move()


func _get_nearest_weapon(actor, weapons: Array, min_distance := 0.0):
	
	var nearest_weapon = null
	var nearest_distance = null
	
	for weapon in weapons:
		var distance = (actor.global_transform.origin - weapon.global_transform.origin).length()
		if (nearest_distance == null or distance < nearest_distance) and distance < min_distance:
			nearest_distance = distance
			nearest_weapon = weapon
	return nearest_weapon

func _on_build(object):
	
	_on_Timer_timeout()
	

func _on_Timer_timeout():
	
	
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
	
	var team = get_team()
	
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
	
	
	print("[%s] Construct goal : %s" % [self.team, constructor.target_pattern_name])
	
	
	for team_member in team:
		
		if constructor.target_pattern_name == "" or constructor.target_ready_to_build():
			set_goal(team_member, { "near_constructor": true, "box_dropped": true})
			var take_boxe_action = team_member.get_node("GoapPlanner/TakeBox")
			if take_boxe_action:
				take_boxe_action.min_distance = 10.0
		#elif not constructor.ready_to_build() :
		#	set_goal(team_member, { "builder_ready": true })
		#	var take_boxe_action = team_member.get_node("GoapPlanner/TakeBox")
		#	if take_boxe_action:
		#		take_boxe_action.min_distance = 0.0
		
		if not team_member.has_object() and weapons_count > 0:
			
			var nearest_weapon = _get_nearest_weapon(team_member, weapons, 10.0)
			
			if nearest_weapon != null:
				set_goal(team_member, { "have_weapon": true })
				weapons_count -= 1
		
	
	#
	# Nearest team member make the build if ready
	#
	if constructor.target_pattern_name != "" and not constructor.target_ready_to_build():
		var nearest_member = null
		var nearest_distance = null
		
		for team_member in team:
			var distance = (team_member.global_transform.origin - constructor.global_transform.origin).length()
			
			if nearest_distance == null or distance < nearest_distance:
				nearest_distance = distance
				nearest_member = team_member
		
		if nearest_member != null:
			set_goal(nearest_member, { "builder_ready": true })
	
	if constructor.target_pattern_name != "" and constructor.target_ready_to_build():
		
		print("[%s] Ready to build" % [self.team] )
		
		var nearest_member = null
		var nearest_distance = null
		
		for team_member in team:
			var distance = (team_member.global_transform.origin - constructor.global_transform.origin).length()
			
			if nearest_distance == null or distance < nearest_distance:
				nearest_distance = distance
				nearest_member = team_member
		
		if nearest_member != null:
			set_goal(nearest_member, { "build_done": true })
	
	
	#
	# Agressive
	#
	if team.size() >= max_team - 2 and not ennemies.empty():
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
	
	
	
	

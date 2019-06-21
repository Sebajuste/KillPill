extends Node

export var team = ""
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
	

func compare_goals(expect: Dictionary, state: Dictionary):
	
	for key in expect:
		if not state.has(key) or expect[key] != state[key]:
			return false
	return true
	

# Called when the node enters the scene tree for the first time.
func _ready():
	
	_on_Timer_timeout()
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_goal(team_member, goal_state):
	
	if not compare_goals(goal_state, team_member.get_node("GoapPlanner").goal_state):
		print("new goal: ", goal_state)
		team_member.get_node("GoapPlanner").goal_state = goal_state
		team_member.cancel_move()
	

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
	
	#
	# Build & Equipe
	#
	
	constructor.target_pattern_name = "gun"
	
	for team_member in team:
		#set_goal(team_member, { "build_done": true })
		set_goal(team_member, { "near_constructor": true, "box_dropped": true })
		var take_boxe_action = team_member.get_node("GoapPlanner/TakeBox")
		if take_boxe_action:
			take_boxe_action.min_distance = 5.0
		
		if not team_member.has_object() and weapons_count > 0:
			set_goal(team_member, { "have_weapon": true })
			weapons_count -= 1
		
		if team_member.has_object():
			team_equiped_count += 1
	
	#
	# Agressive
	#
	if team.size() == team_equiped_count:
		for team_member in team:
			set_goal(team_member, { "attack": true })
		return
	
	#
	# Protect constructor
	#
	for ennemy in get_ennemies():
		
		var constructor_distance = (constructor.global_transform.origin - ennemy.global_transform.origin).length()
		
		if constructor_distance < 15:
			
			for team_member in team:
				
				var team_member_distance = (team_member.global_transform.origin - ennemy.global_transform.origin).length()
				
				if team_member_distance < 20:
					set_goal(team_member, { "attack": true })
	
	
	
	

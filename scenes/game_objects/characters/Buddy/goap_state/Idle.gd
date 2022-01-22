extends PlayerState


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(_delta):
	
	if state_machine.goap_planner.goal_state.empty():
		return
	
	var constructor = _find_constructor()
	
	if constructor:
		var constructor_distance = (constructor.global_transform.origin - player.global_transform.origin).length()
		
		state_machine.goap_planner.world_state["builder_ready"] = constructor.target_ready_to_build()
		state_machine.goap_planner.world_state["builder_full"] = constructor.target_ready_to_build()
		state_machine.goap_planner.world_state["near_constructor"] = constructor_distance < 10
	else:
		state_machine.goap_planner.world_state["near_constructor"] = false
	
	state_machine.goap_planner.world_state["hold_box"] = player.is_holding()
	state_machine.goap_planner.world_state["have_weapon"] = player.has_object()
	state_machine.goap_planner.world_state["have_ammo"] = player.has_object() and player.get_object().ammo > 0
	state_machine.goap_planner.world_state["see_ammo"] = not get_tree().get_nodes_in_group("ammo").empty()
	state_machine.goap_planner.world_state["see_heal"] = not get_tree().get_nodes_in_group("heal").empty()
	state_machine.goap_planner.world_state["see_ennemy"] = not player.ennemies.empty()
	
	# warning-ignore:integer_division
	state_machine.goap_planner.world_state["health_low"] = player.combat_stats.health < ( (20 * player.combat_stats.max_health) / 100  )
	
	state_machine.goap_planner.goal_state["health_low"] = false
	
	var context = {
		"team": player.team,
		"position": player.global_transform.origin,
		"constructor": constructor,
		"ennemies": player.ennemies
	}
	
	var action_list = state_machine.goap_planner.create_plan(context)
	
	if not action_list.empty():
		_show_plan(action_list)
		state_machine.transition_to("Goap/Animation", {
			"action_list": action_list
		})
		
	else:
		print("[%s] Cannot create plan state : " % owner.get_name())
		print("> state: ", state_machine.goap_planner.world_state)
		print("> goal : ", state_machine.goap_planner.goal_state)
		state_machine.goap_planner.goal_state = {}
	
	pass


func enter(message : Dictionary = {}):
	if message.has("goal_state"):
		state_machine.goap_planner.goal_state = message.goal_state
	parent.looking = false


func _find_constructor():
	var constructors = get_tree().get_nodes_in_group("constructor")
	var constructor = null
	for c in constructors:
		if c.team == player.team:
			constructor = c
			break
	return constructor


func _show_plan(action_list):
	var action_plan = ""
	for a in action_list:
		action_plan += "> %s " % a.get_name()
	print("[%s] Action Plan : " % get_name(), action_plan, state_machine.goap_planner.world_state, state_machine.goap_planner.goal_state)

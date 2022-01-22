extends PlayerGoapAction


func execute(actor: Player):
	
	var constructors = get_tree().get_nodes_in_group("constructor")
	var constructor = null
	for c in constructors:
		if c.team == actor.team:
			constructor = c
			break
	
	if constructor == null:
		return false
	
	move_to_object(constructor)
	
	if not yield(goap_planner.goap_state_machine, "on_move_reached"):
		print("Cannot end BringBoxNearConstruct action")
		emit_signal("on_action_end", false)
		return
	
	emit_signal("on_action_end", true)

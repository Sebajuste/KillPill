extends PlayerGoapAction


func execute(actor) -> bool:
	
	
	if not actor.is_holding():
		return false
	
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
		print("Cannot end BringBoxToConstruct action")
		emit_signal("on_action_end", false)
		return
	
	var target_transform = constructor.global_transform
	target_transform.origin.y = actor.global_transform.origin.y
	
	var rotTransform = target_transform.looking_at(actor.global_transform.origin, Vector3.UP)
	actor.global_transform = Transform(rotTransform.basis, actor.global_transform.origin)
	
	var result : bool = actor.constructor_put_box(constructor, actor.get_holded() )
	emit_signal("on_action_end", result )
	return result

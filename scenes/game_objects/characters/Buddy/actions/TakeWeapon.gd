extends PlayerGoapAction


func is_reachable(_context: Dictionary) -> bool:
	for weapon in get_tree().get_nodes_in_group("weapon"):
		if not weapon.owned:
			return true
	return false


func execute(actor):
	
	print("Execute take weapon")
	
	var catchables = get_tree().get_nodes_in_group("object_container")
	
	var nearest_weapon = null
	var nearset_distance := 0.0
	
	for catchable in catchables:
		
		var object = catchable.get_object()
		
		if object == null or not object.is_in_group("weapon"):
			break
		
		var distance = (actor.global_transform.origin - catchable.global_transform.origin).length()
		
		if nearest_weapon == null or distance < nearset_distance:
			nearset_distance = distance
			nearest_weapon = catchable
	
	if nearest_weapon == null:
		return false
	
	var weapon_ref = weakref(nearest_weapon)
	
	move_to_object(nearest_weapon)
	
	if not yield(goap_planner.goap_state_machine, "on_move_reached"):
		print("Cannot end TakeBox action")
		emit_signal("on_action_end", false)
		return
	
	if not weapon_ref.get_ref():
		emit_signal("on_action_end", false)
		return
	
	var result = actor.take_object( weapon_ref.get_ref() )
	print("take weapon result : ", result)
	emit_signal("on_action_end", result)
	

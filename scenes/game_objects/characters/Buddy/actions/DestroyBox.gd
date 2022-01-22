extends PlayerGoapAction


func is_reachable(_context: Dictionary) -> bool:
	
	var boxes = get_tree().get_nodes_in_group("box")
	
	for box in boxes:
		if not box.catched:
			return true
	
	return false


func execute(actor):
	
	var boxes = get_tree().get_nodes_in_group("box")
	
	var nearest_box = null
	var nearset_distance := 0.0
	
	for box in boxes:
		var distance = (actor.global_transform.origin - box.global_transform.origin).length()
		
		if nearest_box == null or distance < nearset_distance:
			nearset_distance = distance
			nearest_box = box
	
	if nearest_box == null:
		return false
	
	var box_ref = weakref(nearest_box)
	
	move_to_object(nearest_box, 0.5)
	
	if not yield(goap_planner.goap_state_machine, "on_move_reached"):
		print("Cannot end TakeBox action")
		emit_signal("on_action_end", false)
		return
	
	if not box_ref.get_ref() or box_ref.get_ref().catched:
		emit_signal("on_action_end", false)
		return
	
	
	# Orientation to box
	
	var target_transform = box_ref.get_ref().global_transform
	target_transform.origin.y = actor.global_transform.origin.y
	
	var rotTransform = target_transform.looking_at(actor.global_transform.origin, Vector3.UP)
	actor.global_transform = Transform(rotTransform.basis, actor.global_transform.origin)
	
	emit_signal("on_action_end", actor.punch() )
	

extends PlayerGoapAction


export var min_distance := 1.0


func get_constructor(actor):
	var constructors = get_tree().get_nodes_in_group("constructor")
	var constructor = null
	for c in constructors:
		if c.team == actor.team:
			constructor = c
			break
	return constructor


func is_reachable(_context: Dictionary) -> bool:
	
	var boxes = get_tree().get_nodes_in_group("box")
	
	if boxes.empty():
		return false
	
	for box in boxes:
		if not box.catched:
			return true
	
	return false


func execute(actor):
	
	var constructor = get_constructor(actor)
	
	var boxes = get_tree().get_nodes_in_group("box")
	
	var nearest_box = null
	var nearset_distance := 0.0
	
	for box in boxes:
		if not box.catched:
			var distance = (actor.global_transform.origin - box.global_transform.origin).length()
			
			var constructor_distance = 0
			if constructor != null:
				constructor_distance = (box.global_transform.origin - constructor.global_transform.origin).length()
			
			if not box.catched and (constructor == null or constructor_distance > min_distance) and ( nearest_box == null or distance < nearset_distance):
				nearset_distance = distance
				nearest_box = box
	
	
	if nearest_box == null:
		return false
	
	var box_ref = weakref(nearest_box)
	
	move_to_object(nearest_box)
	
	if not yield(goap_planner.goap_state_machine, "on_move_reached"):
		print("Cannot end TakeBox action")
		emit_signal("on_action_end", false)
		return
	
	var box = box_ref.get_ref()
	if box == null or box.catched:
		emit_signal("on_action_end", false)
	else:
		emit_signal("on_action_end", actor.hold_object( box_ref.get_ref() ) )
	
	
	

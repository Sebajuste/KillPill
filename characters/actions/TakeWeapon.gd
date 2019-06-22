extends "res://addons/goap/goap_action.gd"

func is_reachable(context: Dictionary) -> bool:
	
	for weapon in get_tree().get_nodes_in_group("weapon"):
		
		if not weapon.owned:
			return true
		
	return false

func execute(actor):
	
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
	
	actor._move_target_ref = weapon_ref
	
	actor.go_to(nearest_weapon.global_transform.origin)
	
	if not yield(actor, "on_move_reached"):
		print("Cannot end TakeBox action")
		emit_signal("on_action_end", false)
		return
	
	if not weapon_ref.get_ref():
		emit_signal("on_action_end", false)
		return
	
	var result = actor.take_object( weapon_ref.get_ref() )
	print("take weapon result : ", result)
	emit_signal("on_action_end", result)
	
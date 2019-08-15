extends "res://addons/goap/goap_action.gd"

func execute(actor):
	
	var heal_list = get_tree().get_nodes_in_group("heal")
	
	var nearest_heal = null
	var nearset_distance := 0.0
	
	for heal in heal_list:
		var distance = (actor.global_transform.origin - heal.global_transform.origin).length()
		
		if nearest_heal == null or distance < nearset_distance:
			nearset_distance = distance
			nearest_heal = heal
	
	if nearest_heal == null:
		return false
	
	actor.move_to_object(nearest_heal)
	
	if not yield(actor, "on_move_reached"):
		print("Cannot end TakeHeal action")
		emit_signal("on_action_end", false)
		return
	emit_signal("on_action_end", true)
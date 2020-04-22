extends "res://addons/goap/goap_action.gd"

func execute(actor):
	
	var ammo_list = get_tree().get_nodes_in_group("ammo")
	
	var nearest_ammo = null
	var nearset_distance := 0.0
	
	for ammo in ammo_list:
		var distance = (actor.global_transform.origin - ammo.global_transform.origin).length()
		
		if nearest_ammo == null or distance < nearset_distance:
			nearset_distance = distance
			nearest_ammo = ammo
	
	if nearest_ammo == null:
		return false
	
	actor.move_to_object(nearest_ammo)
	
	if not yield(actor, "on_move_reached"):
		print("Cannot end TakeAmmo action")
		emit_signal("on_action_end", false)
		return
	emit_signal("on_action_end", true)
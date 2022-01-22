extends PlayerGoapAction



func execute(actor) -> bool:
	
	if not actor.ennemies.empty():
		return true
	
	#actor.connect(""
	
	actor.connect("ennemy_detected", self, "_on_ennemy_detected")
	
	# Go to random location
	var x = rand_range(-50.0, 50.0)
	var z = rand_range(-50.0, 50.0)
	
	
	var position := NavigationManager.get_closest_point( Vector3(x, 0.0, z) )
	
	move_to_position( position, 5.0 )
	
	if not yield(goap_planner.goap_state_machine, "on_move_reached"):
		print("Cannot end SearchEnnemy action")
		emit_signal("on_action_end", not actor.ennemies.empty())
		actor.disconnect("ennemy_detected", self, "_on_ennemy_detected")
		return false
	
	actor.disconnect("ennemy_detected", self, "_on_ennemy_detected")
	
	emit_signal("on_action_end", not actor.ennemies.empty())
	return not actor.ennemies.empty()


func _on_ennemy_detected(player, ennemy):
	
	print("ennemy detected")
	
	player.stop_move()
	
	pass

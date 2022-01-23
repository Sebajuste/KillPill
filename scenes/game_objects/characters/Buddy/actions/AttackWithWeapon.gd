extends PlayerGoapAction


export(Resource) var boid_config


export(float) var attack_range := 15.0


var target_ref = null

"""
func is_reachable(context: Dictionary) -> bool:
	
	target_ref = null
	
	var target = nearest_ennemy(context["position"], context["ennemies"])
	
	if target != null:
		target_ref = weakref( target )
	
	if target == null:
		print("No ennemy found")
	return target != null
"""

func cost(context: Dictionary) -> float:
	
	var nearest_character = nearest_ennemy(context["position"], context["ennemies"])
	
	if nearest_character == null:
		return 0.0
	
	return (nearest_character.global_transform.origin - context["position"]).length()


func execute(actor) -> bool:
	
	"""
	var target = target_ref.get_ref()
	
	if target == null:
		print("invalid target")
		return false
	"""
	
	var target = nearest_ennemy(actor.global_transform.origin, actor.ennemies)
	
	if target == null:
		print("No ennemy found")
		return false
	
	target_ref = weakref( target )
	
	
	# Check the distance, and if the target is visible
	var space_state : PhysicsDirectSpaceState = actor.get_world().direct_space_state
	
	var intersect = space_state.intersect_ray(
		actor.global_transform.origin + Vector3.UP,
		target.global_transform.origin + Vector3.UP,
		[actor]
	)
	
	if actor.global_transform.origin.distance_squared_to(target.global_transform.origin) > attack_range * attack_range or (not intersect.has("collider") or intersect.collider != target):
		print("> need to move")
		move_to_object(target, attack_range, true)
		
		if not yield(goap_planner.goap_state_machine, "on_move_reached"):
			print("> cannot reach target position")
			emit_signal("on_action_end", false)
			return false
	
	target = target_ref.get_ref()
	
	# Target always valid ?
	if target == null:
		print("> invalid target 2")
		emit_signal("on_action_end", false)
		return false
	
	
	# Target visible and in range ?
	"""
	var space_state : PhysicsDirectSpaceState = actor.get_world().direct_space_state
	
	var intersect = space_state.intersect_ray(
		actor.global_transform.origin + Vector3.UP,
		target.global_transform.origin + Vector3.UP,
		[actor]
	)
	
	if not intersect.has("collider") or intersect.collider != target:
		print("> need to move")
		move_to_object(target, attack_range)
		if not yield(goap_planner.goap_state_machine, "on_move_reached"):
			print("> cannot reach target position")
			emit_signal("on_action_end", false)
			return false
	"""
	
	var ai_handler = actor.control_state_machine.state
	
	# Keep good range distance
	ai_handler.boid_config = boid_config
	ai_handler.enable_boid = true
	
	# Define shoot direction
	ai_handler.enable_target = true
	ai_handler.target_ref = weakref(target)
	
	if actor.have_weapon():
		var weapon : Node = actor.get_weapon()
		
		if weapon.ready_to_shoot:
			return _shoot(ai_handler, weapon)
		
		yield(weapon, "shoot_ready")
		return _shoot(ai_handler, weapon)
		
	
	ai_handler.enable_boid = false
	ai_handler.enable_target = false
	
	emit_signal("on_action_end", false)
	return false


func _shoot(ai_handler, weapon):
	var result = weapon.shoot()
	ai_handler.enable_boid = false
	ai_handler.enable_target = false
	emit_signal("on_action_end", result)
	return result


func nearest_ennemy(position: Vector3, ennemies : Array) -> Spatial:
	
	var target = null
	var nearset_distance := 0.0
	
	for ennemy in ennemies:
		var distance = (position - ennemy.global_transform.origin).length()
		
		if not ennemy.dead and ( target == null or distance < nearset_distance ):
			nearset_distance = distance
			target = ennemy
	
	return target

extends PlayerGoapAction


const attack_distance := 1.5

var target_ref = null

"""
func is_reachable(context: Dictionary) -> bool:
	
	target_ref = null
	
	var target = nearest_ennemy(context["position"], context["ennemies"])
	
	if target != null:
		target_ref = weakref( target )
	
	return target != null
"""

func cost(context: Dictionary) -> float:
	
	var nearest_character = nearest_ennemy(context["position"], context["ennemies"])
	
	if nearest_character == null:
		return 0.0
	
	return (nearest_character.global_transform.origin - context["position"]).length()
	
	"""
	target_ref = null
	var ennemy = nearest_ennemy(context)
	if ennemy == null:
		return 0.0
	
	target_ref = weakref( ennemy )
	
	return ennemy.global_transform.origin.length()
	"""


func execute(actor):
	
	"""
	var characters = get_tree().get_nodes_in_group("character")
	
	var nearest_character = null
	var nearset_distance := 0.0
	
	for character in characters:
		var distance = (actor.global_transform.origin - character.global_transform.origin).length()
		
		if character.team != actor.team and not character.dead and ( nearest_character == null or distance < nearset_distance ):
			nearset_distance = distance
			nearest_character = character
	"""
	
	#var nearest_character = _nearest_ennemy(actor.team, actor.global_transform.origin)
	
	"""
	if nearest_character == null:
		print("No ennemy found")
		return false
	
	var target_ref := weakref(nearest_character)
	"""
	
	var nearest_character = nearest_ennemy(actor.global_transform.origin, actor.ennemies)
	
	if nearest_character == null:
		print("No ennemy found")
		return false
	
	target_ref = weakref( nearest_character )
	
	"""
	var nearest_character = target_ref.get_ref()
	
	if nearest_character == null:
		print("invalid target")
		return false
	"""
	
	# Check distance and move to target if needed
	var distance_squared = actor.global_transform.origin.distance_squared_to(nearest_character.global_transform.origin)
	
	if (attack_distance + 1.0) * (attack_distance + 1.0) < distance_squared:
		print("Need to move to target")
		move_to_object(nearest_character, attack_distance)
		
		if not yield(goap_planner.goap_state_machine, "on_move_reached"):
			print("Cannot end AttackWithFists action")
			emit_signal("on_action_end", false)
			return false
	
	# Target already valid ?
	if not target_ref.get_ref():
		print("No valid target")
		emit_signal("on_action_end", false )
		return false
	
	# Re check distance to attack
	distance_squared = actor.global_transform.origin.distance_squared_to(nearest_character.global_transform.origin)
	if (attack_distance + 1.0) * (attack_distance + 1.0) < distance_squared :
		print("Target too far")
		emit_signal("on_action_end", false)
		return false
	
	
	# Orientation to target
	
	"""
	var target_transform = target_ref.get_ref().global_transform
	target_transform.origin.y = actor.global_transform.origin.y
	
	var rotTransform = target_transform.looking_at(actor.global_transform.origin, Vector3.UP)
	actor.global_transform = Transform(rotTransform.basis, actor.global_transform.origin)
	"""
	
	var ai_handler = actor.control_state_machine.state
	
	
	ai_handler.goap.look_target = target_ref.get_ref().global_transform.origin
	
	# Attack
	var result : bool = actor.punch()
	print("Attack done")
	emit_signal("on_action_end", result )
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

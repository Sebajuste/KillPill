extends "res://addons/goap/goap_action.gd"


var target_ref = null


func is_reachable(context: Dictionary) -> bool:
	
	var target = null
	var nearset_distance := 0.0
	
	target_ref = null
	
	for ennemy in context["ennemies"]:
		var distance = (context["position"] - ennemy.global_transform.origin).length()
		
		if not ennemy.dead and ( target == null or distance < nearset_distance ):
			nearset_distance = distance
			target = ennemy
	
	if target != null:
		target_ref = weakref( target )
	
	return target != null

func execute(actor):
	
	var target = target_ref.get_ref()
	
	if target == null:
		print("No target !")
		actor.target_pos = null
		return false
	
	actor.target_pos = target.global_transform.origin
	
	var distance = (actor.global_transform.origin - target.global_transform.origin).length()
	
	if distance < 20:
		
		actor.go_to(target.global_transform.origin, 20)
		
		if not yield(actor, "on_move_reached"):
			emit_signal("on_action_end", false)
	
	
	if not target_ref.get_ref():
		actor.target_pos = null
		emit_signal("on_action_end", false)
		return false
	
	var target_transform = target.global_transform
	target_transform.origin.y = actor.global_transform.origin.y
	
	var rotTransform = target_transform.looking_at(actor.global_transform.origin, Vector3.UP)
	actor.global_transform = Transform(rotTransform.basis, actor.global_transform.origin)
	
	actor.target_pos = actor._next_shoot_pos(target)
	
	var result = actor.shoot()
	emit_signal("on_action_end", result)
	
	actor.target_pos = null
	
	return result

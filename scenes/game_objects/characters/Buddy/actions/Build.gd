extends "res://addons/goap/goap_action.gd"

func execute(actor):
	
	var constructors = get_tree().get_nodes_in_group("constructor")
	var constructor = null
	for c in constructors:
		if c.team == actor.team:
			constructor = c
			break
	
	if constructor == null:
		return false
	
	actor.move_to_object(constructor)
	
	if not yield(actor, "on_move_reached"):
		print("Cannot end Build action")
		emit_signal("on_action_end", false)
		return
	
	var target_transform = constructor.global_transform
	target_transform.origin.y = actor.global_transform.origin.y
	
	var rotTransform = target_transform.looking_at(actor.global_transform.origin, Vector3.UP)
	actor.global_transform = Transform(rotTransform.basis, actor.global_transform.origin)
	
	emit_signal("on_action_end", actor.constructor_build(constructor) )

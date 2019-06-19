extends "res://addons/goap/goap_action.gd"

func execute(actor):
	
	var characters = get_tree().get_nodes_in_group("character")
	
	var target = null
	var nearset_distance := 0.0
	
	for character in characters:
		var distance = (actor.global_transform.origin - character.global_transform.origin).length()
		
		if character.team != actor.team and not character.dead and ( target == null or distance < nearset_distance ):
			nearset_distance = distance
			target = character
	
	if target == null:
		return false
	
	#var dir = (target.global_transform.origin - actor.global_transform.origin).normalized()
	#actor.global_transform.basis.z  = dir
	
	#var rotTransform = actor.global_transform.looking_at(target.global_transform.origin, Vector3.UP)
	#var thisRotation = Quat(actor.global_transform.basis).slerp(rotTransform.basis, turret_rotation_speed * delta)
	#actor.global_transform = Transform(thisRotation, actor.global_transform.origin)
	
	var target_transform = target.global_transform
	target_transform.origin.y = actor.global_transform.origin.y
	
	var rotTransform = target_transform.looking_at(actor.global_transform.origin, Vector3.UP)
	actor.global_transform = Transform(rotTransform.basis, actor.global_transform.origin)
	
	return actor.shoot()

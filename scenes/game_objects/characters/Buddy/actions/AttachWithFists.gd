extends "res://addons/goap/goap_action.gd"

func execute(actor):
	
	var characters = get_tree().get_nodes_in_group("character")
	
	var nearest_character = null
	var nearset_distance := 0.0
	
	for character in characters:
		var distance = (actor.global_transform.origin - character.global_transform.origin).length()
		
		if character.team != actor.team and not character.dead and ( nearest_character == null or distance < nearset_distance ):
			nearset_distance = distance
			nearest_character = character
	
	if nearest_character == null:
		return false
	
	var target_ref := weakref(nearest_character)
	
	actor.move_to_object(nearest_character)
	
	if not yield(actor, "on_move_reached"):
		print("Cannot end TakeBox action")
		emit_signal("on_action_end", false)
		return
	
	# Orientation to target
	
	if not target_ref.get_ref():
		emit_signal("on_action_end", false )
		return
	
	var target_transform = target_ref.get_ref().global_transform
	target_transform.origin.y = actor.global_transform.origin.y
	
	var rotTransform = target_transform.looking_at(actor.global_transform.origin, Vector3.UP)
	actor.global_transform = Transform(rotTransform.basis, actor.global_transform.origin)
	
	emit_signal("on_action_end", actor.punch() )
	

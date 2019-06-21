extends "res://addons/goap/goap_action.gd"

export var min_distance := 1.0


func get_constructor(actor):
	var constructors = get_tree().get_nodes_in_group("constructor")
	var constructor = null
	for c in constructors:
		if c.team == actor.team:
			constructor = c
			break
	
	return constructor

func execute(actor):
	
	var constructor = get_constructor(actor)
	
	var constructor_distance = 0
	if constructor != null:
		constructor_distance = (actor.global_transform.origin - constructor.global_transform.origin).length()
	
	
	var boxes = get_tree().get_nodes_in_group("box")
	
	var nearest_box = null
	var nearset_distance := 0.0
	
	for box in boxes:
		var distance = (actor.global_transform.origin - box.global_transform.origin).length()
		
		if not box.catched and (constructor == null or constructor_distance > min_distance) and ( nearest_box == null or distance < nearset_distance):
			nearset_distance = distance
			nearest_box = box
	
	if nearest_box == null:
		return false
	
	
	
	
	
	var box_ref = weakref(nearest_box)
	
	actor._move_target_ref = box_ref
	
	actor.go_to(nearest_box.global_transform.origin)
	
	if not yield(actor, "on_move_reached"):
		print("Cannot end TakeBox action")
		emit_signal("on_action_end", false)
		return
	
	if (!box_ref.get_ref()):
		emit_signal("on_action_end", false)
	else:
		emit_signal("on_action_end", actor.hold_object( box_ref.get_ref() ) )
	
	
	

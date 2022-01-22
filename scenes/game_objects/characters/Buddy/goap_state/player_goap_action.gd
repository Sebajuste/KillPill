class_name PlayerGoapAction
extends GoapAction


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func move_to_object(object : Spatial, target_distance := 1.0, target_visible := false):
	goap_planner.goap_state_machine.transition_to("Goap/MoveTo", {
		"target_ref": weakref(object),
		"target_distance": target_distance,
		"target_visible": target_visible
	})


func move_to_position(position : Vector3, target_distance := 1.0):
	goap_planner.goap_state_machine.transition_to("Goap/MoveTo", {
		"target_position": position,
		"target_distance": target_distance
	})
	

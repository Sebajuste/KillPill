extends DebugStatusValue




# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_GoapPlanner_action_list_updated(action_list):
	
	set_property("Plan", _action_list_to_string(action_list) )
	


func _on_GoapSM_transitioned(state_path, msg):
	
	set_property("State", state_path)
	


static func _action_list_to_string(action_list) -> String:
	var action_plan = ""
	for a in action_list:
		action_plan += "> %s " % a.get_name()
	return action_plan

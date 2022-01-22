tool
extends EditorPlugin


func _enter_tree():
	
	add_custom_type("GoapPlanner", "Node", load("goap_planner.gd"), null )
	add_custom_type("GoapAction", "Node", load("goap_action.gd"), null )
	
	add_custom_type("GoaptActionResource", "Resource", load("goap_action_resource.gd"), null)
	

func _exit_tree():
	
	remove_custom_type("GoapPlanner")
	remove_custom_type("GoapAction")
	remove_custom_type("GoaptActionResource")
	

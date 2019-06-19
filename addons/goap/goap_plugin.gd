tool
extends EditorPlugin


func _enter_tree():
	
	add_custom_type("GoapPlanner", "Node", preload("goap_planner.gd"), null )
	add_custom_type("GoapAction", "Node", preload("goap_action.gd"), null )
	

func _exit_tree():
	
	remove_custom_type("GoapPlanner")
	remove_custom_type("GoapAction")
	

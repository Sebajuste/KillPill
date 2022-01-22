tool
extends EditorPlugin


func _enter_tree():
	
	add_custom_type("AStarGridVector2", "Node", load("vector2/grid_vector2.gd"), null)
	
	pass

func _exit_tree():
	
	remove_custom_type("AStarGridVector2")
	
	pass

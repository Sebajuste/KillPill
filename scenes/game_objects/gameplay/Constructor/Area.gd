extends Area

# Declare member variables here. Examples:
# var a = 2
# var b = "text"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func has_object() -> bool:
	
	return $ObjectContainer.get_child_count() > 0
	


func add_object(object : Node) -> bool:
	if not has_object() and object.is_in_group("catchable"):
		$ObjectContainer.add_child(object)
		object.catched = true
		return true
	return false


func remove_object() -> Node:
	if has_object():
		var object = $ObjectContainer.get_child(0)
		$ObjectContainer.remove_child(object)
		object.catched = false
		return object
	return null


func delete_object():
	if has_object():
		$ObjectContainer.get_child(0).queue_free()


func _on_Area_body_entered(_body):
	
	#$MeshInstance.visible = true
	
	pass # Replace with function body.


func _on_Area_body_exited(_body):
	
	#$MeshInstance.visible = false
	
	pass # Replace with function body.


func _on_Area_area_entered(area):
	var character = area.get_parent()
	if character.is_holding():
		get_parent().get_parent().add_helper(self, area)


func _on_Area_area_exited(area):
	var character = area.get_parent()
	if character.is_holding():
		get_parent().get_parent().remove_helper(self, area)

extends Area

func has_object() -> bool:
	return get_parent().find_node("ObjectContainer").get_child_count() > 0

func set_object(object):
	if not has_object():
		get_parent().find_node("ObjectContainer").add_child(object)

func get_object():
	if has_object():
		return get_parent().find_node("ObjectContainer").get_child(0)
	return null

func take_object():
	if has_object():
		var object = get_parent().find_node("ObjectContainer").get_child(0)
		get_parent().find_node("ObjectContainer").remove_child(object)
		get_parent().queue_free()
		return object
	return null
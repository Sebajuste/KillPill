extends Node


var navigation : Navigation setget set_navigation, get_navigation
var navigation_ref : WeakRef = weakref(null)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func get_simple_path(start: Vector3, end: Vector3) -> PoolVector3Array:
	var nav: Navigation = navigation_ref.get_ref()
	if nav != null:
		var path := nav.get_simple_path(start, end)
		#path.append(end)
		path.append( nav.get_closest_point(end) )
		return path
	else:
		var path := PoolVector3Array()
		path.append(start)
		path.append(end)
		#path.append( nav.get_closest_point(end) )
		return path


func get_closest_point(to_point: Vector3) -> Vector3:
	var nav: Navigation = navigation_ref.get_ref()
	if nav != null:
		return nav.get_closest_point(to_point)
	return to_point


func set_navigation(value: Navigation):
	if value != null:
		navigation_ref = weakref(value)


func get_navigation() -> Navigation:
	
	return navigation_ref.get_ref()
	

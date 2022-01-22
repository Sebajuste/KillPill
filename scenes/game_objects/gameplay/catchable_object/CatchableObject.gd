tool
extends RigidBody


const OBJECT_PATHS = {
	"Gun": "res://scenes/game_objects/objects/weapons/gun/Gun.tscn"
}


export(String, "None", "Gun") var object_name = "None" setget set_object_name
export var animated = true setget set_animated


var initialized := false


# Called when the node enters the scene tree for the first time.
func _ready():
	
	if animated:
		$AnimationPlayer.play("rotation")
	
	set_object_name(object_name)
	initialized = true


func has_object() -> bool:
	return $ObjectContainer.get_child_count() > 0


func set_object(object):
	if not has_object():
		$ObjectContainer.add_child(object)


func take_object() -> Node:
	if has_object():
		var object = $ObjectContainer.get_child(0)
		$ObjectContainer.remove_child(object)
		queue_free()
		return object
	return null



func set_object_name(value):
	object_name = value
	
	if OBJECT_PATHS.has(value):
		var scene := load( OBJECT_PATHS.get(value) )
		var obj = scene.instance()
		set_object( obj )
	
	if initialized and value == "None" and has_object():
		$ObjectContainer.get_child(0).queue_free()
	


func set_animated(a):
	
	if a:
		$AnimationPlayer.play("rotation")
	else:
		$AnimationPlayer.stop(true)
	animated = a
	





func _on_LifeTimer_timeout():
	
	queue_free()
	

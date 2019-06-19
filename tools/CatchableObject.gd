extends RigidBody


export var animated = true setget _set_animated



func has_object() -> bool:
	return $ObjectContainer.get_child_count() > 0

func set_object(object):
	if not has_object():
		$ObjectContainer.add_child(object)

func take_object():
	if has_object():
		var object = $ObjectContainer.get_child(0)
		$ObjectContainer.remove_child(object)
		queue_free()
		return object
	return null


func _set_animated(a):
	
	if a:
		$AnimationPlayer.play("rotation")
	else:
		$AnimationPlayer.stop(true)
	animated = a
	

# Called when the node enters the scene tree for the first time.
func _ready():
	
	if animated:
		$AnimationPlayer.play("rotation")


func _process(delta):
	
	pass
	


func _on_LifeTimer_timeout():
	
	queue_free()
	

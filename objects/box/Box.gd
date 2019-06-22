extends RigidBody


var Ammo = preload("res://objects/ammo/Ammo.tscn")
var Health = preload("res://objects/health/Health.tscn")

var catched = false


func is_catched() -> bool:
	return catched

func hold(owner) -> bool:
	
	if not catched:
		mode = RigidBody.MODE_STATIC
		catched = true
		return true
	return false


func release():
	catched = false
	mode = RigidBody.MODE_RIGID
	



func damage(position, normal, bullet):
	
	if catched:
		return
	
	for i in range(5):
		
		var drop
		
		if randf() > 0.3:
			drop = Ammo.instance()
		else:
			drop = Health.instance()
		
		var root = get_tree().get_root().get_node("Game")
		root.find_node("Objects").add_child(drop)
		
		drop.global_transform.origin = self.global_transform.origin + Vector3.UP * 2
		drop.apply_central_impulse( Vector3(rand_range(-1, 1), rand_range(0, 1), rand_range(-1, 1) ).normalized() * 2 )
		
		
	
	queue_free()
	
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

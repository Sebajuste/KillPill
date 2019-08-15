extends RigidBody


var Ammo = preload("res://objects/ammo/Ammo.tscn")
var Health = preload("res://objects/health/Health.tscn")

var catched = false

var _collision_mask 
var _collision_layer

func is_catched() -> bool:
	return catched

func hold(owner) -> bool:
	
	if not catched:
		mode = RigidBody.MODE_STATIC
		catched = true
		_collision_mask = get_collision_mask()
		_collision_layer = get_collision_layer()
		set_collision_mask(0x00)
		set_collision_layer(0x00)
		$PickSound.play()
		return true
	return false


func release():
	if catched:
		catched = false
		mode = RigidBody.MODE_RIGID
		set_collision_mask(_collision_mask)
		set_collision_layer(_collision_layer)
		$PickSound.play()



func damage(position, normal, bullet):
	
	if catched:
		return
	
	for i in range(3):
		
		var drop
		
		if randf() > 0.5:
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

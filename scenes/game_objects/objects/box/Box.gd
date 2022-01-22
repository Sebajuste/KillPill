extends RigidBody


var Ammo = preload("res://scenes/game_objects/objects/ammo/Ammo.tscn")
var Health = preload("res://scenes/game_objects/objects/health/Health.tscn")


var catched = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass	


func is_catched() -> bool:
	
	return catched
	


func hold(_owner) -> bool:
	
	if not catched:
		mode = RigidBody.MODE_STATIC
		catched = true
		$CollisionShape.disabled = true
		$PickSound.play()
		return true
	return false


func release():
	if catched:
		catched = false
		mode = RigidBody.MODE_RIGID
		$CollisionShape.disabled = false
		$PickSound.play()


func _on_CombatStats_health_depleted():
	
	if catched:
		return
	
	for _i in range(3):
		
		var drop
		
		if randf() > 0.5:
			drop = Ammo.instance()
		else:
			drop = Health.instance()
		
		Game.add_node_in_level(drop)
		
		drop.global_transform.origin = self.global_transform.origin + Vector3.UP * 2
		drop.apply_central_impulse( Vector3(rand_range(-1, 1), rand_range(0, 1), rand_range(-1, 1) ).normalized() * 2 )
	
	queue_free()
	

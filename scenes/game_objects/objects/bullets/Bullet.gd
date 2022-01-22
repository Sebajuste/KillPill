extends KinematicBody


var velocity = Vector3()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_damage(value):
	
	$DamageSource.damage = value
	


func set_source(value):
	
	$DamageSource.source = value
	


func _physics_process(delta):
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		$AudioStreamPlayer3D.play()
		velocity = velocity.bounce(collision.normal)


func _on_Timer_timeout():
	
	queue_free()
	


func _on_DamageSource_hit(_hit_box):
	
	queue_free()
	

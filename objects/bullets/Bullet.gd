extends KinematicBody


export var speed = 20.0

var damage = 0

var velocity = Vector3()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _physics_process(delta):
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		$AudioStreamPlayer3D.play()
		velocity = velocity.bounce(collision.normal)
		if collision.collider.has_method("damage"):
			collision.collider.damage(collision.position, collision.normal, self)
	

func _on_Timer_timeout():
	
	queue_free()
	


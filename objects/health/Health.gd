extends RigidBody

export var heal = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Area_body_entered(body):
	
	if body.heal( heal ):
		queue_free()
	


func _on_Timer_timeout():
	
	queue_free()
	

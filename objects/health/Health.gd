extends RigidBody

export var heal = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Area_body_entered(body):
	
	body.heal( heal )
	
	queue_free()
	

extends PlayerState


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func get_look_position() -> Vector3:
	
	return player.global_transform.origin
	

func get_move_target() -> Vector3:
	
	return player.global_transform.origin
	
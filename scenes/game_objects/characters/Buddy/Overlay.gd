extends Control


export var y_offset := 1.7

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	var pos = owner.global_transform.origin
	
	var cam = get_tree().get_root().get_camera()
	
	if cam:
		var screen_pos = cam.unproject_position(pos + Vector3.UP * y_offset)
		set_position( Vector2(screen_pos.x - rect_size.x/2, screen_pos.y - rect_size.y/2) )
	

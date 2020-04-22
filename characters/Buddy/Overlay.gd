extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var pos = global_transform.origin
	
	var cam = get_tree().get_root().get_camera()
	
	var screen_pos = cam.unproject_position(pos)
	
	$HealthProgressBar.set_position( Vector2(screen_pos.x - $HealthProgressBar.rect_size.x/2, screen_pos.y-60) )
	

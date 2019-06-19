extends Camera

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _pivot

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_as_toplevel(true)
	
	_pivot = self.global_transform.origin - get_parent().global_transform.origin
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	self.global_transform.origin = get_parent().global_transform.origin + _pivot
	
	
	
	pass

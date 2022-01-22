extends Spatial



export(NodePath) var target_path
export var offset : Vector3 = Vector3(0, 8.7, 10)

onready var target_ref := weakref(get_node(target_path))


# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_as_toplevel(true)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var target = target_ref.get_ref()
	
	if target:
		var target_pos = target.global_transform.origin + Vector3(0, 8.7, 10)
		self.global_transform.origin = self.global_transform.origin.linear_interpolate(target_pos, delta * 4)


func set_target(target : Spatial):
	
	target_ref = weakref(target)
	


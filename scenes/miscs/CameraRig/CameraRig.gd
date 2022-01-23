class_name CameraRig
extends Spatial


export(String, "Follow") var mode := "Follow" setget set_mode
export(NodePath) var target_path


export var min_distance := 1.0
export var max_distance := 10.0
export var distance := 2.0


export var rotation_speed := 0.1 # PI / 2

export var zoom_range := Vector2(2.0, 7.0) setget set_zoom_range
export var zoom := 5.0 setget set_zoom
export var zoom_speed := 1.5

export var current := true setget set_current

onready var target_ref := weakref(get_node(target_path))
onready var pivot : Spatial = $Pivot
onready var camera : Camera = $Pivot/InterpolatedCamera
onready var spring_arm : SpringArm = $Pivot/SpringArm


# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_as_toplevel(true)
	
	if target_path:
		target_ref = weakref(get_node(target_path))
	else:
		target_ref = weakref(null)
	
	set_mode(mode)
	set_zoom_range(zoom_range)
	set_zoom(zoom)
	set_current(current)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	"""
	var target = target_ref.get_ref()
	
	if target:
		var target_pos = target.global_transform.origin + Vector3(0, 8.7, 10)
		self.global_transform.origin = self.global_transform.origin.linear_interpolate(target_pos, delta * 4)
	"""
	
	spring_arm.spring_length = lerp(spring_arm.spring_length, zoom, delta)


func set_target(target : Spatial):
	if target:
		target_ref = weakref(target)
	


func set_mode(value):
	mode = value
	$ControlSM.transition_to("Control/%s" % value)


func set_zoom_range(value):
	value.x = max(value.x, 0.0)
	value.y = max(value.y, 0.0)
	zoom_range.x = min(value.x, value.y)
	zoom_range.y = max(value.x, value.y)


func set_zoom(value):
	
	zoom = clamp(value, zoom_range.x, zoom_range.y)
	


func set_current(value):
	current = value
	if camera:
		camera.current = value

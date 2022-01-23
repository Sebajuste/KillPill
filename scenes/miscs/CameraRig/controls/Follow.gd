extends CameraRigState


const ANGLE_X_MIN: = -PI/4
const ANGLE_X_MAX: =  PI/3


export var offset_y := 10.0


var mouse_position_saved := Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func enter(_msg: Dictionary = {}):
	
	camera_rig.set_as_toplevel(true)
	


func physics_process(delta):
	
	_parent.physics_process(delta)
	
	
	var target : Spatial = camera_rig.target_ref.get_ref()
	if target:
		
		var target_pos = target.global_transform.origin + Vector3.UP * offset_y
		
		var offset : Vector3 = camera_rig.global_transform.origin - target_pos
		
		offset = offset.normalized() * camera_rig.distance
		
		camera_rig.look_at_from_position(
			target_pos + offset,
			target.global_transform.origin,
			Vector3.UP
		)
	


func input(event : InputEvent):
	
	_parent.input(event)
	


func unhandled_input(event):
	
	if event is InputEventMouseButton and event.is_action_pressed("move_camera"):
		mouse_position_saved = event.position
		_parent.move_camera = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().set_input_as_handled()
	
	elif event is InputEventMouseButton and event.is_action_released("move_camera") and _parent.move_camera:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		_parent.move_camera = false
		get_viewport().warp_mouse(mouse_position_saved)
		get_tree().set_input_as_handled()
	else:
		_parent.unhandled_input(event)
	

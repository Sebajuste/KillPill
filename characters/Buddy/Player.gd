extends "res://characters/Buddy/Buddy.gd"

var _last_mouse_pos

var use_mouse = true

func _mouse_look(mouse_pos) -> Vector3:
	
	# Get the 3D cursor position
	
	mouse_pos += Vector2(16, 16)
	
	var ray_length = 1000
	
	get_tree()
	
	#var camera = $Camera
	var camera = get_tree().get_root().get_node("Game/Environment/Camera")
	
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to)
	
	var dir = Vector3()
	
	if result:
		dir = (result.position - global_transform.origin)
		dir.y = 0
		dir = dir.normalized()
		
		$Target.global_transform.origin = result.position
	
	
	
	
	return dir

func _control(delta):
	
	#
	# Action
	#
	
	var action_done = false
	
	if Input.is_action_pressed("shoot"):
		action_done = shoot()
	
	if not action_done and Input.is_action_just_pressed("punch"):
		action_done = punch()
	
	if not action_done and Input.is_action_just_pressed("catch"):
		action_done = catch_front()
	
	if not action_done and Input.is_action_just_pressed("use"):
		action_done = use_front()
	
	if not action_done and Input.is_action_just_pressed("drop"):
		if is_holding():
			release_hold()
		else:
			drop_object()
	
	#
	# Move
	#
	var dir =._control(delta)
	
	if Input.get_action_strength("move_up"):
		dir += Vector3.FORWARD * Input.get_action_strength("move_up")
	
	if Input.get_action_strength("move_down"):
		dir += Vector3.BACK * Input.get_action_strength("move_down")
	
	if Input.get_action_strength("move_right"):
		dir += Vector3.RIGHT * Input.get_action_strength("move_right")
	
	if Input.get_action_strength("move_left"):
		dir += Vector3.LEFT * Input.get_action_strength("move_left")
	
	#
	# Look
	#
	
	look_dir = Vector3()
	
	var mouse_pos = get_viewport().get_mouse_position()
	
	if _last_mouse_pos != mouse_pos or use_mouse:
		_last_mouse_pos = mouse_pos
		use_mouse = true
		$Target.visible = true
		look_dir = _mouse_look( get_viewport().get_mouse_position() )
	
	var temp_dir = look_dir
	
	#if Input.get_action_strength("look_up"):
	look_dir += Vector3.FORWARD * Input.get_action_strength("look_up")
	
	#if Input.get_action_strength("look_down"):
	look_dir += Vector3.BACK * Input.get_action_strength("look_down")
	
	#if Input.get_action_strength("look_right"):
	look_dir += Vector3.RIGHT * Input.get_action_strength("look_right")
	
	#if Input.get_action_strength("look_left"):
	look_dir += Vector3.LEFT * Input.get_action_strength("look_left")
	
	if temp_dir != look_dir:
		use_mouse = false
		$Target.visible = false
	
	look_dir = look_dir.normalized()
	
	return dir.normalized()


func _ready():
	
	$Target.set_as_toplevel(true)
	

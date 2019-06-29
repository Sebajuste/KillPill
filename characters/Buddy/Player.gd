extends "res://characters/Buddy/Buddy.gd"

var _last_mouse_pos

var use_mouse = true

var look_target_pos = null
var target_ref = null

func _mouse_look(mouse_pos) -> Vector3:
	
	# Get the 3D cursor position
	
	mouse_pos += Vector2(16, 16)
	
	var ray_length = 1000
	
	get_tree()
	
	var camera = get_tree().get_root().get_camera()
	
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
		
		target_pos = result.position
	
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
	
	
	if Input.is_action_just_released("lock_target"):
		$Target.visible = false
		target_ref = null
	
	if temp_dir != look_dir:
		use_mouse = false
		
		$Target.visible = false
		
		var near_dot = null
		
		
		if not Input.is_action_pressed("lock_target"):
			
			look_target_pos = null
			target_ref = null
			
			for ennemy in ennemies:
				
				var ennemy_dir = (ennemy.global_transform.origin - global_transform.origin).normalized()
				
				var r = ennemy_dir.dot(look_dir.normalized())
				
				if r > 0.98:
					if near_dot == null or r > near_dot:
						near_dot = r
						look_target_pos = ennemy.global_transform.origin
						target_ref = weakref(ennemy)
	
	if target_ref != null and target_ref.get_ref() != null:
		
		var target = target_ref.get_ref()
		
		look_target_pos = target.global_transform.origin
		
		$Target.visible = true
		$Target.global_transform.origin = look_target_pos
		
		if Input.is_action_pressed("lock_target"):
			look_dir = (target.global_transform.origin - global_transform.origin).normalized()
		
		if has_object():
			target_pos = _next_shoot_pos(target)
		else:
			target_pos = null
		
	elif not use_mouse:
		$Target.visible = false
		target_pos = null
	
	look_dir = look_dir.normalized()
	
	return dir.normalized()


func _ready():
	
	$Target.set_as_toplevel(true)
	

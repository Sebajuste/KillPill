extends Node

export(String, "Keyboard", "GamePad1", "Both") var controller := "Both" setget set_controller

var enable := false setget set_enable

var _last_mouse_pos

var use_mouse = true

var look_target_pos = null
var target_ref = null


func _ready():
	
	$Target.set_as_toplevel(true)
	


func set_controller(value: String):
	controller = value


func set_enable(value: bool):
	enable = value
	$Target.visible = enable


func add_object_to_constructor(object, constructor):
	
	var catch_area = get_node("../CatchArea")
	
	return constructor.add_object(catch_area, object)


func _mouse_look(mouse_pos) -> Vector3:
	
	# Get the 3D cursor position
	
	mouse_pos += Vector2(16, 16)
	
	var ray_length = 1000
	
	get_tree()
	
	var camera = get_tree().get_root().get_camera()
	
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	
	var space_state = get_parent().get_world().direct_space_state
	var result = space_state.intersect_ray(from, to)
	
	var dir = Vector3()
	
	if result:
		
		dir = (result.position - get_parent().global_transform.origin)
		dir.y = 0
		dir = dir.normalized()
		
		$Target.global_transform.origin = result.position
		
		get_parent().target_pos = result.position
	
	return dir


func control(delta) -> Vector3:
	
	if not enable:
		print("oups")
		return Vector3()
	
	#
	# Action
	#
	
	var action_done = false
	
	if Input.is_action_pressed("shoot"):
		action_done = get_parent().shoot()
	
	if not action_done and Input.is_action_just_pressed("punch"):
		action_done = get_parent().punch()
	
	if not action_done and Input.is_action_just_pressed("catch"):
		action_done = get_parent().catch_front()
	
	if not action_done and Input.is_action_just_pressed("use"):
		action_done = get_parent().use_front()
	
	if not action_done and Input.is_action_just_pressed("drop"):
		if get_parent().is_holding():
			get_parent().release_hold()
		else:
			get_parent().drop_object()
	
	#
	# Move
	#
	var dir = Vector3()
	
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
	
	get_parent().look_dir = Vector3()
	
	var mouse_pos = get_viewport().get_mouse_position()
	
	if _last_mouse_pos != mouse_pos or use_mouse:
		_last_mouse_pos = mouse_pos
		use_mouse = true
		$Target.visible = true
		get_parent().look_dir = _mouse_look( get_viewport().get_mouse_position() )
	
	
	var temp_dir = get_parent().look_dir
	
	#if Input.get_action_strength("look_up"):
	get_parent().look_dir += Vector3.FORWARD * Input.get_action_strength("look_up")
	
	#if Input.get_action_strength("look_down"):
	get_parent().look_dir += Vector3.BACK * Input.get_action_strength("look_down")
	
	#if Input.get_action_strength("look_right"):
	get_parent().look_dir += Vector3.RIGHT * Input.get_action_strength("look_right")
	
	#if Input.get_action_strength("look_left"):
	get_parent().look_dir += Vector3.LEFT * Input.get_action_strength("look_left")
	
	
	if Input.is_action_just_released("lock_target"):
		$Target.visible = false
		target_ref = null
	
	if temp_dir != get_parent().look_dir:
		use_mouse = false
		
		$Target.visible = false
		
		var near_dot = null
		
		
		if not Input.is_action_pressed("lock_target"):
			
			look_target_pos = null
			target_ref = null
			
			for ennemy in get_parent().ennemies:
				
				var ennemy_dir = (ennemy.global_transform.origin - get_parent().global_transform.origin).normalized()
				
				var r = ennemy_dir.dot( get_parent().look_dir.normalized())
				
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
			get_parent().look_dir = (target.global_transform.origin - get_parent().global_transform.origin).normalized()
		
		if get_parent().has_object():
			get_parent().target_pos = get_parent()._next_shoot_pos(target)
		else:
			get_parent().target_pos = null
		
	elif not use_mouse:
		$Target.visible = false
		get_parent().target_pos = null
	
	get_parent().look_dir = get_parent().look_dir.normalized()
	
	return dir.normalized()

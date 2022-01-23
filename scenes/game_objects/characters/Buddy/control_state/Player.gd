extends PlayerState


var shooting := false


var look_position := Vector3.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Target.set_as_toplevel(true)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta):
	
	parent.process(delta)
	
	if Input.is_action_pressed("shoot"):
		player.shoot()


func physics_process(delta):
	parent.physics_process(delta)
	
	if Controller.type == Controller.Type.MOUSE_KEYBOARD:
		look_position = _get_mouse_look_position()
	elif Controller.type == Controller.Type.GAMEPAD:
		var look_direction = _get_look_input_direction()
		if not look_direction.is_equal_approx(Vector3.ZERO):
			look_position = player.global_transform.origin + look_direction
		else:
			look_position = Vector3.ZERO


func unhandled_input(event: InputEvent):
	
	if event.is_action_pressed("catch"):
		player.catch_front()
	
	if event.is_action_pressed("drop"):
		if player.is_holding():
			player.release_hold()
		else:
			player.drop_object()
	
	if event.is_action_pressed("punch"):
		player.punch()
	
	if event.is_action_pressed("shoot"):
		shooting = true
	if event.is_action_released("shoot"):
		shooting = false
	
	if event.is_action_pressed("use"):
		player.use_front()
	
	
	pass


func enter(_message : Dictionary = {}):
	
	if Controller.type == Controller.Type.MOUSE_KEYBOARD:
		$Target.visible = true
	
	Controller.connect("controller_changed", self, "_on_controller_changed")
	


func exit():
	
	shooting = false
	
	$Target.visible = false
	
	Controller.disconnect("controller_changed", self, "_on_controller_changed")
	


func get_look_position() -> Vector3:
	if look_position:
		return look_position
	var velocity = player.get_velocity()
	return player.global_transform.origin + Vector3(velocity.x, 0.0, velocity.z)


func get_move_target() -> Vector3:
	
	return player.global_transform.origin + _get_move_direction().normalized() * 10
	


func _get_mouse_look_position() -> Vector3:
	var mouse_pos := get_viewport().get_mouse_position()
	
	var camera := get_tree().get_root().get_camera()
	
	if not camera:
		return Vector3.ZERO
	
	var from := camera.project_ray_origin(mouse_pos)
	var to := from + camera.project_ray_normal(mouse_pos) * 1000
	
	var space_state := player.get_world().direct_space_state
	var result := space_state.intersect_ray(from, to)
	
	if result:
		var dir : Vector3 = (result.position - player.global_transform.origin)
		dir.y = 0
		dir = dir.normalized()
		
		$Target.global_transform.origin = result.position
		
		return result.position
	else:
		return Vector3.ZERO
	
	pass





func _get_input_direction() -> Vector3:
	return Vector3(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		0,
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)


func _get_move_direction() -> Vector3:
	var input_direction: Vector3 = _get_input_direction()
	#var forwards: Vector3 = player.camera.global_transform.basis.z * input_direction.z
	#var right: Vector3 = player.camera.global_transform.basis.x * input_direction.x
	
	var camera = get_tree().get_root().get_camera()
	if camera:
		var forwards: Vector3 = camera.global_transform.basis.z * input_direction.z
		var right: Vector3 = camera.global_transform.basis.x * input_direction.x
		return forwards + right
	return input_direction


func _get_look_input_direction() -> Vector3:
	return Vector3(
		Input.get_action_strength("look_right") - Input.get_action_strength("look_left"),
		0,
		Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	)


func _on_controller_changed(type):
	
	match type:
		Controller.Type.MOUSE_KEYBOARD:
			$Target.visible = true
		Controller.Type.GAMEPAD:
			$Target.visible = false
	
	pass

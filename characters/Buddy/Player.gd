extends "res://characters/Buddy/Buddy.gd"

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
	
	if Input.get_action_strength("move_up") > 0.1:
		dir += Vector3.FORWARD * Input.get_action_strength("move_up")
	
	if Input.get_action_strength("move_down") > 0.1:
		dir += Vector3.BACK * Input.get_action_strength("move_down")
	
	if Input.get_action_strength("move_right") > 0.1:
		dir += Vector3.RIGHT * Input.get_action_strength("move_right")
	
	if Input.get_action_strength("move_left") > 0.1:
		dir += Vector3.LEFT * Input.get_action_strength("move_left")
	
	#return dir
	return dir.normalized()
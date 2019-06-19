extends KinematicBody



var CatchableObject = preload("res://tools/CatchableObject.tscn")


export var move_speed = 200.0



func has_object() -> bool:
	
	return $BodyRightHand/RightHand.get_child_count() > 0
	

func take_object(object):
	
	if not has_object():
		$BodyRightHand/RightHand.add_child(object)

func drop_object():
	
	if has_object():
		var object = $BodyRightHand/RightHand.get_child(0)
		$BodyRightHand/RightHand.remove_child(object)
		
		var catchable_object = CatchableObject.instance()
		catchable_object.set_object(object)
		
		var root = get_tree().get_root().get_child(0)
		root.find_node("Objects").add_child(catchable_object)
		
		catchable_object.global_transform.origin = global_transform.origin



func shoot():
	
	var right_hand = $BodyRightHand/RightHand
	if right_hand.get_child_count() > 0:
		var weapon = right_hand.get_child(0)
		weapon.shoot()
	


func _control() -> Vector3:
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#
	# Action
	#
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
	
	if Input.is_action_just_pressed("catch"):
		
		var result = $CatchArea.get_overlapping_areas()
		
		if not result.empty() and result[0].has_object() and not self.has_object():
			var object = result[0].take_object()
			
			take_object(object)
	
	if Input.is_action_just_pressed("drop"):
		drop_object()
	
	
	#
	# Move
	#
	
	var dir = Vector3()
	
	var is_moving = false
	
	if Input.is_action_pressed("move_up"):
		dir += Vector3.FORWARD * move_speed * delta
		is_moving = true
	
	if Input.is_action_pressed("move_down"):
		dir += Vector3.BACK * move_speed * delta
		is_moving = true
	
	if Input.is_action_pressed("move_right"):
		dir += Vector3.RIGHT * move_speed * delta
		is_moving = true
	
	if Input.is_action_pressed("move_left"):
		dir += Vector3.LEFT * move_speed * delta
		is_moving = true
	
	var velocity = self.move_and_slide( dir )
	
	if is_moving:
		var angle = atan2(velocity.x, velocity.z)
		var rot = get_rotation()
		rot.y = angle;
		set_rotation(rot)
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.play("idle")
	
	pass

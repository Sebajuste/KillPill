extends PlayerState


const avoid_obstacle_force := 30.0

var _target_min_distance := 1.5
var _target_visible := false

var _move_path : PoolVector3Array
var _move_index := -1

var _move_target_ref : WeakRef = null
var _move_target_position = null

var _move_reached := false


# Called when the node enters the scene tree for the first time.
func _ready():
	
	$PathDebug.set_as_toplevel(true)
	


func process(_delta: float):
	
	owner.avoid_obstacle_ray.cast_to.z = -max(1.0, player.get_velocity().length() )
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(_delta: float):
	
	if (_move_target_ref == null or _move_target_ref.get_ref() == null ) and _move_target_position == null:
		push_error("[%s] MoveTo : invalid move target ref" % owner.name)
		#print("[MoveTo] : invalid move target ref")
		#state_machine.emit_signal("on_move_reached", false)
		state_machine.transition_to("Goap/Idle")
		return
	
	"""
	var move_target = _move_target_ref.get_ref()
	
	if move_target == null:
		print("[MoveTo] : invalid move target")
		state_machine.transition_to("Goap/Idle")
		return
	"""
	
	var move_position = get_move_position()
	
	if _move_index != -1:
		
		var target_distance = (player.global_transform.origin - move_position).length()
		
		var visible := true
		if _target_visible:
			
			var space_state : PhysicsDirectSpaceState = player.get_world().direct_space_state
			
			var intersect = space_state.intersect_ray(
				player.global_transform.origin + Vector3.UP,
				move_position + Vector3.UP,
				[player]
			)
			
			visible = intersect.has("collider") and intersect.collider != null
		
		
		if _move_index >= _move_path.size() or (target_distance < _target_min_distance and visible):
			_move_target_ref = null
			#print("[MoveTo] : position reached")
			state_machine.transition_to("Goap/Idle")
			#state_machine.emit_signal("on_move_reached", true)
			_move_reached = true
			return
		
		if _move_target_ref != null and !_move_target_ref.get_ref():
			_move_target_ref = null
			#print("[MoveTo] : cannot reach position")
			state_machine.transition_to("Goap/Idle")
			#state_machine.emit_signal("on_move_reached", false)
			return
		
		
		var next_move_target := _move_path[_move_index]
		
		var next_distance_squared := player.global_transform.origin.distance_squared_to(next_move_target)
		
		if next_distance_squared > _target_min_distance * _target_min_distance:
			
			# Avoid obstacle
			if owner.avoid_obstacle_ray.is_colliding():
				var normal : Vector3 = owner.avoid_obstacle_ray.get_collision_normal()
				var point : Vector3 = owner.avoid_obstacle_ray.get_collision_point()
				next_move_target = point + normal * avoid_obstacle_force
			
			parent.move_target = next_move_target
		else:
			_move_index += 1
		
	else:
		#print("[MoveTo] : no more path")
		#state_machine.emit_signal("on_move_reached", true)
		state_machine.transition_to("Goap/Idle")
	
#	pass


func enter(message : Dictionary = {}):
	parent.moving = true
	_move_index = 0
	if  message.has("target_ref"):
		_move_target_position = null
		_move_target_ref = message.target_ref
	else:
		_move_target_ref = null
		_move_target_position = message.target_position
	_move_reached = false
	if message.has("target_distance"):
		_target_min_distance = message.target_distance
	else:
		_target_min_distance = 1.5
	if message.has("target_visible"):
		_target_visible = message.target_visible
	else:
		_target_visible = false
	var move_position = get_move_position()
	if move_position != null:
		_move_path = NavigationManager.get_simple_path(player.global_transform.origin, move_position )
		_update_path_debug()
	else:
		push_error("[%s] MoveTo : Invalid get move position" % owner.name)
		state_machine.transition_to("Goap/Idle")


func exit():
	var move_reached = _move_reached
	_move_reached = false
	_move_index = -1
	_move_target_ref = weakref(null)
	parent.move_target = Vector3.ZERO
	parent.moving = false
	_clear_path_debug()
	state_machine.emit_signal("on_move_reached", move_reached)


func get_move_position() -> Vector3:
	if _move_target_ref != null:
		var move_target = _move_target_ref.get_ref()
		if move_target != null:
			return move_target.global_transform.origin
	return _move_target_position


func _update_path_debug():
	
	$PathDebug.clear()
	
	if _move_path.size() > 1:
		$PathDebug.begin(Mesh.PRIMITIVE_LINE_STRIP)
		
		$PathDebug.add_vertex( player.global_transform.origin )
		
		for index in range(_move_index, _move_path.size() ):
			$PathDebug.add_vertex( _move_path[index] )
		
		"""
		if _move_target_ref:
			var target = _move_target_ref.get_ref()
			if target:
				$PathDebug.add_vertex(target.global_transform.origin)
		"""
		$PathDebug.end()


func _clear_path_debug():
	
	$PathDebug.clear()
	

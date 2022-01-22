extends Node

enum State {IDLE, GO_TO, ANIMATION}

signal on_actions_done

var enable := false setget set_enable

var _state = State.IDLE

var _move_path: PoolVector3Array
var _move_index := -1
var _move_control := Vector3()
var _move_target_ref = null
var _target_final = null
var _target_min_distance = 1.5

var _action_list

func set_enable(value):
	enable = value
	move_cancel()
	_action_list = null
	get_parent().look_dir = Vector3()


func add_object_to_constructor(object, constructor):
	return constructor.add_object_target(object)


func move_to_object(object, min_distance := 1.5) -> bool:
	
	if move_to_position(object.global_transform.origin, min_distance):
		_move_target_ref = weakref(object)
		return true
	return false


func move_to_position(target: Vector3, min_distance := 1.5) -> bool:
	
	_target_final = target
	_target_min_distance = min_distance
	
	var root = get_tree().get_root().get_node("Game")
	
	var nav = root.get_node("Environment/Navigation")
	
	var path : PoolVector3Array = nav.get_simple_path(get_parent().global_transform.origin, target)
	
	if path.size() > 0:
		_move_path = path
		_move_index = 0
		_state = State.GO_TO
		return true
	else:
		print("Cannot go to destination")
		return false


func move_cancel():
	if _move_index != -1:
		_move_target_ref = null
		_target_final = null
		_move_index = -1
		_state = State.IDLE
		get_parent().emit_signal("on_move_reached", false)


func control(_delta) -> Vector3:
	
	return _move_control
	


func _ready():
	
	#$PathDebug.set_as_toplevel(true)
	#$PathDebug.global_transform = Transform()
	pass


func _process(delta):
	
	if not enable:
		return
	
	match _state:
		
		State.IDLE:
			_idle(delta)
			pass
		
		State.GO_TO:
			_move(delta)
			pass
		
		State.ANIMATION:
			_animation(delta)
			pass
	
	_update_path_debug()


func _idle(_delta):
	
	if $GoapPlanner.goal_state.empty():
		return
	
	var constructors = get_tree().get_nodes_in_group("constructor")
	var constructor = null
	for c in constructors:
		if c.team == get_parent().team:
			constructor = c
			break
	
	var constructor_distance = (constructor.global_transform.origin - get_parent().global_transform.origin).length()
	
	$GoapPlanner.world_state["builder_ready"] = constructor.target_ready_to_build()
	$GoapPlanner.world_state["builder_full"] = constructor.target_ready_to_build()
	$GoapPlanner.world_state["hold_box"] = get_parent().is_holding()
	$GoapPlanner.world_state["have_weapon"] = get_parent().has_object()
	$GoapPlanner.world_state["have_ammo"] = get_parent().has_object() and get_parent().get_object().ammo > 0
	$GoapPlanner.world_state["see_ammo"] = not get_tree().get_nodes_in_group("ammo").empty()
	$GoapPlanner.world_state["see_heal"] = not get_tree().get_nodes_in_group("heal").empty()
	$GoapPlanner.world_state["see_ennemy"] = not get_parent().ennemies.empty()
	$GoapPlanner.world_state["near_constructor"] = constructor_distance < 10
	$GoapPlanner.world_state["health_low"] = get_parent().health < ( (20 * get_parent().max_health) / 100  )
	
	$GoapPlanner.goal_state["health_low"] = false
	
	var context = {
		"team": get_parent().team,
		"position": get_parent().global_transform.origin,
		"constructor": constructor,
		"ennemies": get_parent().ennemies
	}
	
	var action_list = $GoapPlanner.create_plan(context)
	
	if not action_list.empty():
		_action_list = action_list
		_state = State.ANIMATION
		#_show_plan(action_list)
	else:
		print("[%s] Cannot create plan state : " % get_parent().get_name())
		print("> state: ", $GoapPlanner.world_state)
		print("> goal : ", $GoapPlanner.goal_state)
		$GoapPlanner.goal_state = {}


func _move(_delta):
	
	_move_control = Vector3()
	
	if _move_index != -1:
		
		var target_distance = (get_parent().global_transform.origin - _target_final).length()
		
		if _move_index >= _move_path.size() or target_distance < _target_min_distance:
			_move_target_ref = null
			_move_index = -1
			_state = State.IDLE
			get_parent().emit_signal("on_move_reached", true)
			return
		
		if _move_target_ref != null and !_move_target_ref.get_ref():
			_move_target_ref = null
			_move_index = -1
			_state = State.IDLE
			get_parent().emit_signal("on_move_reached", false)
		
		var move_target = _move_path[_move_index]
		
		var distance = (get_parent().global_transform.origin - move_target).length()
		
		if distance > 1.5:
			_move_control = (move_target - get_parent().global_transform.origin).normalized()
			
			
			# Todo : avoid obstacle
			
			#var result = $CatchArea.get_overlapping_bodies()
			
			
			
		else:
			_move_index += 1
		
	else:
		_state = State.IDLE
	


func _animation(_delta):
	
	if _action_list != null and not _action_list.empty():
		
		var action = _action_list.pop_front()
		
		var result = action.execute( get_parent() )
		
		if typeof(result) == TYPE_BOOL and result:
			pass
		elif (typeof(result) == TYPE_BOOL and not result) or not result or not yield(action, "on_action_end"):
			
			#_show_plan(_action_list)
			#print("[%s] GOAP cannot reach =" % get_name(), plan )
			_action_list = null
			_state = State.IDLE
			
			return
		
		if _action_list.empty():
			#print("[%s] GOAP done" % get_name() )
			_action_list = null
			emit_signal("on_actions_done", get_parent())
		
		_state = State.IDLE


func _show_plan(action_list):
	var action_plan = ""
	for a in action_list:
		action_plan += "> %s " % a.get_name()
	print("[%s] Action Plan : " % get_name(), action_plan, $GoapPlanner.world_state, $GoapPlanner.goal_state)


func _update_path_debug():
	
	$PathDebug.clear()
	
	if _move_path.size() > 1:
		$PathDebug.begin(Mesh.PRIMITIVE_LINE_STRIP)
		
		$PathDebug.add_vertex( get_parent().global_transform.origin )
		
		for index in range(_move_index, _move_path.size() ):
			$PathDebug.add_vertex( _move_path[index] )
		
		if _move_target_ref:
			var target = _move_target_ref.get_ref()
			if target:
				$PathDebug.add_vertex(target.global_transform.origin)
		
		$PathDebug.end()

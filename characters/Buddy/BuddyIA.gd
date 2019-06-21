extends "res://characters/Buddy/Buddy.gd"

enum State {IDLE, GO_TO, ANIMATION}

signal on_move_reached

var _state = State.IDLE

var _move_path: PoolVector3Array
var _move_index := -1
var _move_control := Vector3()
var _move_target_ref = null

var _action_list



func go_to(target: Vector3):
	
	var root = get_tree().get_root().get_child(0)
	
	var nav = root.get_node("Environment/Navigation")
	
	var path : PoolVector3Array = nav.get_simple_path(global_transform.origin, target)
	
	if path.size() > 0:
		_move_path = path
		_move_index = 0
		_state = State.GO_TO
	else:
		print("Cannot go to destination")

func cancel_move():
	if _move_index != -1:
		_move_target_ref = null
		_move_index = -1
		_state = State.IDLE
		emit_signal("on_move_reached", false)
	



func constructor_put_box(constructor, box) -> bool:
	
	if constructor.is_in_group("constructor") and constructor.team == team:
		
		$HoldPosition.remove_child(box)
		var added = constructor.add_object_target(box)
		if added:
			$BodyRightHand/RightHand.visible = true
			$AnimationTree.set("parameters/HoldObject/blend_amount", 0.0)
			return true
		else:
			$HoldPosition.add_child(box)
	
	return false


func _control(delta) -> Vector3:
	return _move_control

# Called when the node enters the scene tree for the first time.
func _ready():
	
	ia = true
	
	pass # Replace with function body.


var _ennemy_target

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	"""
	var nearest_ennemy = null
	var nearest_distance := 0.0
	
	for ennemy in ennemies:
		var distance = (ennemy.global_transform.origin - self.global_transform.origin).length()
		if nearest_ennemy == null or distance < nearest_distance:
			nearest_distance = distance
			nearest_ennemy = ennemy
	
	if nearest_ennemy != null:
		
		if _ennemy_target != nearest_ennemy:
			print("new target")
			_ennemy_target = nearest_ennemy
			$GoapPlanner.goal_state.clear()
			$GoapPlanner.goal_state["attack"] = true
		pass
	else:
		_ennemy_target = null
		$GoapPlanner.goal_state.clear()
		$GoapPlanner.goal_state["build_done"] = true
	"""
	
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
	
	._process(delta)

func _idle(delta):
	
	var constructors = get_tree().get_nodes_in_group("constructor")
	var constructor = null
	for c in constructors:
		if c.team == self.team:
			constructor = c
			break
	
	$GoapPlanner.world_state["builder_ready"] = constructor.ready_to_build()
	$GoapPlanner.world_state["builder_full"] = constructor.ready_to_build()
	$GoapPlanner.world_state["hold_box"] = is_holding()
	$GoapPlanner.world_state["have_weapon"] = $BodyRightHand/RightHand.get_child_count() > 0
	$GoapPlanner.world_state["have_ammo"] = $BodyRightHand/RightHand.get_child_count() == 0 or $BodyRightHand/RightHand.get_child(0).ammo > 0
	$GoapPlanner.world_state["see_ammo"] = not get_tree().get_nodes_in_group("ammo").empty()
	$GoapPlanner.world_state["see_ennemy"] = not self.ennemies.empty()
	
	#print("world_state : ", $GoapPlanner.world_state )
	
	var action_list = $GoapPlanner.create_plan()
	
	if not action_list.empty():
		_action_list = action_list
		_state = State.ANIMATION
		
		var action_plan = ""
		for a in action_list:
			action_plan += "> %s " % a.get_name()
		#print("Action Plan : ", action_plan)
		
	

func _move(delta):
	
	_move_control = Vector3()
	
	if _move_index != -1:
		
		if _move_index >= _move_path.size():
			_move_target_ref = null
			_move_index = -1
			_state = State.IDLE
			emit_signal("on_move_reached", true)
			return
		
		if _move_target_ref != null and !_move_target_ref.get_ref():
			_move_target_ref = null
			_move_index = -1
			_state = State.IDLE
			emit_signal("on_move_reached", false)
		
		var move_target = _move_path[_move_index]
		
		var distance = (global_transform.origin - move_target).length()
		
		if distance > 1.5:
			_move_control = (move_target - global_transform.origin).normalized()
		else:
			_move_index += 1
		
	else:
		_state = State.IDLE
	
	

func _animation(delta):
	
	if _action_list and not _action_list.empty():
		
		var action = _action_list.pop_front()
		
		#print("Execute ", action.get_name() )
		
		var result = action.execute(self)
		
		#print("result: ", result)
		
		if typeof(result) == TYPE_BOOL and result:
			pass
		elif (typeof(result) == TYPE_BOOL and not result) or not result or not yield(action, "on_action_end"):
			#print("GOAP cannot reach")
			_action_list = null
			_state = State.IDLE
			return
		
		if _action_list.empty():
			#print("GOAP done")
			_action_list = null
		
		_state = State.IDLE
	

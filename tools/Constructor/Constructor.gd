extends Spatial


signal on_build

var CatchableObject = preload("res://tools/CatchableObject.tscn")

var Gun = preload("res://objects/weapons/gun/Gun.tscn")

var Pill = preload("res://characters/Buddy/BuddyIA.tscn")


const GUN1_PATTERN = [[1, 0], [0, 0]]
const GUN2_PATTERN = [[0, 1], [0, 0]]
const GUN3_PATTERN = [[0, 0], [1, 0]]
const GUN4_PATTERN = [[0, 0], [0, 1]]

const PILL1_PATTERN = [[1, 1], [0, 0]]
const PILL2_PATTERN = [[1, 0], [1, 0]]
const PILL3_PATTERN = [[0, 0], [1, 1]]
const PILL4_PATTERN = [[0, 1], [0, 1]]

const PATTERNS = [
	{"name": "pill", "pattern": PILL1_PATTERN},
	{"name": "pill", "pattern": PILL2_PATTERN},
	{"name": "pill", "pattern": PILL3_PATTERN},
	{"name": "pill", "pattern": PILL4_PATTERN},
	
	{"name": "gun", "pattern": GUN1_PATTERN},
	{"name": "gun", "pattern": GUN2_PATTERN},
	{"name": "gun", "pattern": GUN3_PATTERN},
	{"name": "gun", "pattern": GUN4_PATTERN},
]



export var team : String = "Team_0"

var color = ""

var target_pattern_name = null


var _users = {}


func _max_pill_reached() -> bool:
	var count_pill = 0
	for pill in get_tree().get_nodes_in_group("character"):
		if pill.team == self.team:
			count_pill += 1
	return count_pill >= 5

func add_object_target(object) -> bool:
	
	if target_pattern_name == null:
		return false
	
	if target_pattern_name == "pill" and _max_pill_reached():
		return false
	
	var current_pattern: Array = get_current_pattern()
	
	for it_pattern in PATTERNS:
		if it_pattern.name == target_pattern_name:
			
			var pattern = it_pattern.pattern
			
			if current_pattern == pattern:
				print("Construct already ready !")
				return false
			
			if _pattern_can_be_completed(pattern, current_pattern):
				var area = _next_area_to_complete(pattern, current_pattern)
				return area.add_object(object)
			
	
	return false

func add_object(user, object) -> bool:
	var area = select_area(user)
	if area != null:
		return area.add_object(object)
	return false


func ready_to_build() -> bool:
	
	#if target_pattern_name == null:
	if can_build_gun():
		return true
	if can_build_pill():
		return true
	return false
	
	#match target_pattern_name:
	#	"gun":
	#		return can_build_gun()
	#	"pill":
	#		return can_build_pill()

func target_ready_to_build() -> bool:
	
	if target_pattern_name == null:
		return false
	
	match target_pattern_name:
		"gun":
			return can_build_gun()
		"pill":
			return can_build_pill()
		_:
			return false
	


func is_full() -> bool:
	return false


func get_current_pattern() -> Array:
	
	var pattern := [[0, 0], [0, 0]]
	
	for x in range(2):
		for y in range(2):
			if _find_area( Vector2(x, y) ).has_object():
				pattern[x][y] = 1
	
	return pattern
	
	if $Areas/AreaBottomN.has_object():
		pattern[0][0] = 1
	
	if $Areas/AreaBottomE.has_object():
		pattern[1][0] = 1
	
	if $Areas/AreaBottomS.has_object():
		pattern[1][1] = 1
	
	if $Areas/AreaBottomW.has_object():
		pattern[0][1] = 1
	
	return pattern


func can_build_gun() -> bool:
	var pattern = get_current_pattern()
	if pattern == GUN1_PATTERN:
		return true
	if pattern == GUN2_PATTERN:
		return true
	if pattern == GUN3_PATTERN:
		return true
	if pattern == GUN4_PATTERN:
		return true
	return false

func can_build_pill() -> bool:
	var pattern = get_current_pattern()
	if pattern == PILL1_PATTERN:
		return true
	if pattern == PILL2_PATTERN:
		return true
	if pattern == PILL3_PATTERN:
		return true
	if pattern == PILL4_PATTERN:
		return true
	return false

func build() -> bool:
	
	print("build called")
	
	var current_pattern = get_current_pattern()
	
	var pattern_found = null
	for pattern in PATTERNS:
		#if pattern.pattern == current_pattern:
		if _check_pattern(current_pattern, pattern.pattern):
			pattern_found = pattern.name
			break
	
	if pattern_found != null:
		print("pattern found: ", pattern_found)
		
		var root = get_tree().get_root().get_node("Game")
		
		match pattern_found:
			"gun":
				var gun = Gun.instance()
				var catchable_object = CatchableObject.instance()
				catchable_object.set_object(gun)
				root.find_node("Objects").add_child(catchable_object)
				catchable_object.global_transform.origin = self.global_transform.origin
				emit_signal("on_build", catchable_object)
			"pill":
				
				if pattern_found == "pill" and _max_pill_reached():
					return false
				
				var pill = Pill.instance()
				pill.team = self.team
				pill.color = color
				root.find_node("Characters").add_child(pill)
				pill.global_transform.origin = self.global_transform.origin
				emit_signal("on_build", pill)
		
		_delete_pattern(current_pattern)
		return true
	
	return false

func _check_pattern(current_pattern, build_pattern) -> bool:
	for x in range(build_pattern.size()):
		for y in range(build_pattern[x].size()):
			if build_pattern[x][y] == 1 and current_pattern[x][y] == 0:
				return false
	return true

func _delete_pattern(pattern):
	
	for x in range(2):
		for y in range(2):
			_find_area( Vector2(x, y) ).delete_object()
	

func _pattern_can_be_completed(target, pattern) -> bool:
	
	for x in range(target.size()):
		for y in range(target[x].size()):
			if pattern[x][y] and not target[x][y]:
				return false
	
	return true

func _next_area_to_complete(target, pattern):
	for x in range(target.size()):
		for y in range(target[x].size()):
			if target[x][y] and not pattern[x][y]:
				return _find_area( Vector2(x, y) )
	return null

func _find_area(pos: Vector2):
	
	if pos == Vector2(0, 0):
		return $Areas/AreaBottomN
	
	if pos == Vector2(1, 0):
		return $Areas/AreaBottomE
	
	if pos == Vector2(1, 1):
		return $Areas/AreaBottomS
	
	if pos == Vector2(0, 1):
		return $Areas/AreaBottomW
	return null

func _get_or_create_user(user) -> Array:
	if not _users.has(user):
		_users[user] = []
	return _users[user]


func add_helper(area, user):
	
	var array = _get_or_create_user(user)
	
	if not array.has(area):
		array.append( area )
		select_area(user)
	


func remove_helper(area, user):
	
	var array = _users.get(user, [])
	
	if array.has(area):
		array.erase( area )
		area.find_node("MeshInstance").visible = false
		select_area(user)
	
	if array.empty():
		_users.erase(user)


func select_area(user):
	
	var array = _users.get(user, [])
	
	var nearest_area = null
	var nearest_distance = null
	
	for area in array:
		
		var distance = (area.global_transform.origin - user.global_transform.origin).length()
		
		if nearest_distance == null or distance < nearest_distance:
			nearest_distance = distance
			nearest_area = area
		area.find_node("MeshInstance").visible = false
	
	if nearest_area != null:
		nearest_area.find_node("MeshInstance").visible = true
	
	return nearest_area



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Constructor_area_exited(area):
	
	_users.erase(area)
	
	for key in _users:
		var user = _users[key]
		select_area(user)
	
	pass # Replace with function body.

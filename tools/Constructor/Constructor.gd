extends Spatial




var CatchableObject = preload("res://tools/CatchableObject.tscn")

var Gun = preload("res://objects/weapons/gun/Gun.tscn")



const GUN1_PATTERN = [[1, 0], [0, 0]]
const GUN2_PATTERN = [[0, 1], [0, 0]]
const GUN3_PATTERN = [[0, 0], [1, 0]]
const GUN4_PATTERN = [[0, 0], [0, 1]]

const PILL1_PATTERN = [[1, 1], [0, 0]]
const PILL2_PATTERN = [[1, 0], [1, 0]]
const PILL3_PATTERN = [[0, 0], [1, 1]]
const PILL4_PATTERN = [[0, 1], [0, 1]]





export var team : String = "Team_0"



var _users = {}


func add_object(user, object) -> bool:
	var area = select_area(user)
	if area != null:
		return area.add_object(object)
	return false


func ready_to_build() -> bool:
	var areas = []
	for area in $Areas.get_children():
		if area.has_object():
			areas.append(area)
	return not areas.empty()

func is_full() -> bool:
	return false


func get_current_pattern() -> Array:
	
	var pattern := [[0, 0], [0, 0]]
	
	if $Areas/AreaBottomN.has_object():
		pattern[0][0] = 1
	
	if $Areas/AreaBottomE.has_object():
		pattern[1][0] = 1
	
	if $Areas/AreaBottomS.has_object():
		pattern[1][1] = 1
	
	if $Areas/AreaBottomW.has_object():
		pattern[0][1] = 1
	
	return pattern


func build():
	
	var areas = []
	
	for area in $Areas.get_children():
		if area.has_object():
			areas.append(area)
	
	print("Build: ", areas)
	
	if areas.size() == 1:
		
		areas[0].delete_object()
		
		# TODO : build pistol
		
		var gun = Gun.instance()
		
		var catchable_object = CatchableObject.instance()
		catchable_object.set_object(gun)
		
		var root = get_tree().get_root().get_child(0)
		root.find_node("Objects").add_child(catchable_object)
		
		catchable_object.global_transform.origin = self.global_transform.origin
		
		return
	
	
	


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

extends Position3D

var Box = preload("res://objects/box/Box.tscn")

export var start: int = 0
export var max_box = 25


func emit():
	
	var boxes = get_tree().get_nodes_in_group("box")
	
	if boxes.size() > max_box:
		return
	
	var box = Box.instance()
	
	var root_node = get_tree().get_root().get_child(0).find_node("Objects")
	root_node.add_child(box)
	
	box.global_transform.origin = self.global_transform.origin + Vector3(rand_range(-1, 1), 0, rand_range(-1, 1) )

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for i in range(start):
		emit()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	
	emit()
	

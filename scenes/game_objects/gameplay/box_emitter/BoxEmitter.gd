extends Position3D

var Box = preload("res://scenes/game_objects/objects/box/Box.tscn")

export var start: int = 0
export var max_box = 25
export var enabled := true setget set_enabled

# Called when the node enters the scene tree for the first time.
func _ready():
	for _i in range(start):
		call_deferred("emit")
	if enabled:
		$Timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func emit():
	
	var boxes = get_tree().get_nodes_in_group("box")
	
	if boxes.size() >= max_box:
		return
	
	var box = Box.instance()
	
	Game.add_node_in_level(box)
	
	box.global_transform.origin = self.global_transform.origin + Vector3(rand_range(-1, 1), 0, rand_range(-1, 1) )


func set_enabled(value : bool):
	enabled = value
	if enabled:
		$Timer.start()
	else:
		$Timer.stop()


func _on_Timer_timeout():
	
	emit()
	

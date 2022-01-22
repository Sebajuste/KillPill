extends PlayerState



#var _action_list : Array = Array()


var move_target := Vector3.ZERO setget set_move_target
var moving := false


var look_target := Vector3.ZERO setget set_look_target
var looking


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func set_move_target(value: Vector3):
	move_target = value
	if not move_target.is_equal_approx(Vector3.ZERO):
		moving = true


func set_look_target(value: Vector3):
	look_target = value
	if not look_target.is_equal_approx(Vector3.ZERO):
		looking = true

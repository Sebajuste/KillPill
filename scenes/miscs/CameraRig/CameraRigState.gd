class_name CameraRigState
extends State


var camera_rig : CameraRig


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(self.owner, "ready")
	camera_rig = self.owner


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

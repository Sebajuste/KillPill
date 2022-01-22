class_name PlayerState
extends State



var player : Player


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(self.owner, "ready")
	player = self.owner


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

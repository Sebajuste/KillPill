extends PlayerState


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func physics_process(delta):
	parent.physics_process(delta)
	if player.is_on_floor() and parent.velocity.length_squared() > 0.1:
		state_machine.transition_to("Locomotion/Walk")


func enter(_message : Dictionary = {}):
	
	player.skin.play_animation("idle")
	

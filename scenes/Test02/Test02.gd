extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	for teams in $Teams.get_children():
		
		if teams.get_team().empty():
			$GameOver.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	


func _on_Player_on_death():
	
	$GameOver.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	pass # Replace with function body.

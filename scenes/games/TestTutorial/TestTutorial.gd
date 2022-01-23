extends "res://scenes/games/Solo/Solo.gd"


onready var tutorial = $Level/Tutorial


func _init():
	
	parameters = {
		"teams": ["Blue"],
		"player_team": "Blue"
	}
	
	


# Called when the node enters the scene tree for the first time.
func _ready():
	
	print("test tuto ready")
	
	#camera.set_target(tutorial.player)
	
	#camera.global_transform.origin = tutorial.player.global_transform.origin + Vector3(0, 0, 1)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

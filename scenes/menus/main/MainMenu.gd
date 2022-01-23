extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	VisualServer.set_default_clear_color(Color(0.0,0.0,0.0,1.0))
	
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_TutorialButton_pressed():
	
	"""
	Loading.load_scene("res://scenes/levels/tutorial/Tutorial.tscn", {
		"switch": true
	})
	"""
	
	Loading.load_level({
		"parent": "root",
		"path": "res://scenes/games/Solo/Solo.tscn",
		"childs": [{
			"path": "res://scenes/levels/tutorial/Tutorial.tscn"
		}],
		"parameters": {
			"teams": ["Blue"],
			"player_team": "Blue"
		}
	})
	


func _on_PlayButton_pressed():
	"""
	Loading.load_scene("res://scenes/games/Solo/Solo.tscn", {
		"switch": true,
		"level": "res://scenes/levels/level01/Level01.tscn",
		"teams": ["Blue", "Red", "Yellow", "Green"],
		"player_team": "Blue",
		"root": true
	})
	
	Loading.load_scene("res://scenes/levels/level01/Level01.tscn", {
		"child": true
	})
	"""
	
	Loading.load_level({
		"path": "res://scenes/games/Solo/Solo.tscn",
		"childs": [
			{
				"path": "res://scenes/levels/level01/Level01.tscn"
			}
		],
		"parameters": {
			"teams": ["Blue", "Red", "Yellow", "Green"],
			"player_team": "Blue"
		}
	})
	
	pass


func _on_OptionsButton_pressed():
	
	$Options.reload()
	$Options.visible = true
	
	pass # Replace with function body.


func _on_Options_on_close():
	
	$Options.visible = false
	


func _on_QuitButton_pressed():
	
	get_tree().quit()
	


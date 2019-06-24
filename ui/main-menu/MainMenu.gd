extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	VisualServer.set_default_clear_color(Color(0.0,0.0,0.0,1.0))
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_TutorialButton_pressed():
	
	get_tree().change_scene("res://scenes/Tutorial/Tutorial.tscn")
	

func _on_PlayButton_pressed():
	
	get_tree().change_scene("res://scenes/Test02/Test02.tscn")
	

func _on_OptionsButton_pressed():
	
	$Options.reload()
	$Options.visible = true
	
	pass # Replace with function body.


func _on_Options_on_close():
	
	$Options.visible = false
	


func _on_QuitButton_pressed():
	
	get_tree().quit()
	








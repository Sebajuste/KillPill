extends CanvasLayer

signal on_close

export var visible := false setget set_visible


func set_visible(value):
	visible = value
	get_tree().paused = visible
	
	$MarginContainer.visible = visible
	
	if visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		emit_signal("on_close")
	

func toggle() -> bool:
	
	set_visible(not visible)
	return visible

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_visible( visible )
	

func _on_ResumeButton_pressed():
	
	set_visible(false)
	


func _on_OptionsButton_pressed():
	
	$MarginContainer.visible = false
	$Options.visible = true
	


func _on_ReturnMenuButton_pressed():
	
	get_tree().paused = false
	
	Loading.load_scene("res://scenes/menus/main/MainMenu.tscn", {"switch": true})
	


func _on_ExitGameButton_pressed():
	
	get_tree().quit()
	


func _on_Options_on_close():
	
	$MarginContainer.visible = true
	$Options.visible = false
	

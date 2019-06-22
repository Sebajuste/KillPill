extends CanvasLayer


export var visible := true setget set_visible


func set_visible(value):
	visible = value
	
	$MarginContainer.visible = visible
	

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_visible(visible)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RestartButton_pressed():
	
	get_tree().change_scene("res://scenes/Test02/Test02.tscn")
	


func _on_BackMainButton_pressed():
	
	get_tree().change_scene("res://ui/main-menu/MainMenu.tscn")
	

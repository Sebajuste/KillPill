extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_progress(min_value : float, max_value : float, value : float):
	
	$MarginContainer/ProgressBar.min_value = min_value
	$MarginContainer/ProgressBar.max_value = max_value
	
	#var percentage : float = (value / max_value) * 100
	
	#print("percentage : ", percentage)
	
	$ProgressTween.interpolate_property($MarginContainer/ProgressBar, "value", $MarginContainer/ProgressBar.value, value, 0.1)
	$ProgressTween.start()
	


func _on_Loading_visibility_changed():
	
	$MarginContainer/ProgressBar.value = 0
	

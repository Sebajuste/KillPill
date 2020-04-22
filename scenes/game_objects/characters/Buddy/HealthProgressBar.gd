extends TextureProgress

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Buddy_on_health_change(value, max_value):
	
	var percent = (value * 100) / max_value
	
	$Tween.interpolate_property(
		self, "value",
		self.value, percent, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	
	if percent >= 100:
		self.visible = false
	else:
		self.visible = true
	
	$Tween.start()
	


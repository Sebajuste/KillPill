extends TextureProgress


var displayed := false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	modulate.a = 0.0
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Buddy_on_health_change(value, max_value):
	
	var percent : float = (value * 100) / max_value
	
	$Tween.interpolate_property(
		self, "value",
		self.value, percent, 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	
	if value == max_value:
		#self.visible = false
		
		if displayed:
			$TweenFade.interpolate_property(
				self, "modulate",
				Color(modulate.r, modulate.g, modulate.b, 1.0),
				Color(modulate.r, modulate.g, modulate.b, 0.0),
				0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
			)
			$TweenFade.start()
			displayed = false
	else:
		#self.visible = true
		if not displayed:
			$TweenFade.interpolate_property(
				self, "modulate",
				Color(modulate.r, modulate.g, modulate.b, 0.0),
				Color(modulate.r, modulate.g, modulate.b, 1.0),
				0.2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
			)
			$TweenFade.start()
			displayed = true
	
	$Tween.start()
	

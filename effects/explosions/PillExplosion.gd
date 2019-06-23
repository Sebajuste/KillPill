extends Spatial

var color setget set_color


func set_color(value):
	
	color = value
	
	match color:
		"Blue":
			var material = load("res://characters/Buddy/BodyBlue.material")
			$Particles.draw_pass_1.material = material
		"Red":
			var material = load("res://characters/Buddy/BodyRed.material")
			$Particles.draw_pass_1.material = material
		"Yellow":
			var material = load("res://characters/Buddy/BodyYellow.material")
			$Particles.draw_pass_1.material = material

# Called when the node enters the scene tree for the first time.
func _ready():
	
	$Particles.emitting = true
	$Particles.restart()
	$AudioStreamPlayer3D.play()
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	
	queue_free()
	

extends Spatial




onready var animation_tree := $"../AnimationTree"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	animation_tree.active = true
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func play_animation(name: String):
	
	match name:
		"idle":
			animation_tree["parameters/Move/playback"].travel("idle")
		"walk":
			animation_tree["parameters/Move/playback"].travel("walk-cycle")
		
		"punch":
			if $PunchTimer.is_stopped():
				animation_tree.set("parameters/Punch/active", true)
				$BodyLeftHand/LeftHand/DamageSource/CollisionShape.disabled = false
				$PunchTimer.start()
		
		"catch_object":
			$BodyRightHand/RightHand.visible = false
			animation_tree.set("parameters/HoldObject/blend_amount", 1.0)
		"release_object":
			$BodyRightHand/RightHand.visible = true
			animation_tree.set("parameters/HoldObject/blend_amount", 0.0)
		
		"hit":
			animation_tree.set("parameters/Hit/active", true)
	
	pass


func _on_PuchTimer_timeout():
	
	$BodyLeftHand/LeftHand/DamageSource/CollisionShape.disabled = true
	pass # Replace with function body.


func _on_DamageSource_hit(_hit_box):
	
	$BodyLeftHand/LeftHand/DamageSource/CollisionShape.disabled = true
	

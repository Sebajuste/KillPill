extends CSGCombiner


var WallDamage = preload("res://prefabs/wall-damage/WallDamage01.tscn")


func hit(position: Vector3, normal: Vector3):
	
	var wall_damage = WallDamage.instance()
	
	print("hit pos: ", position )
	
	add_child(wall_damage)
	
	wall_damage.global_transform.origin = position - get_parent().global_transform.origin
	
	
	
	print( "parent : ", get_parent().global_transform.origin, ", final : ", wall_damage.global_transform.origin )
	
	print("hit")
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

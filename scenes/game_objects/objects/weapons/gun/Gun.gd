extends Spatial

var Bullet = preload("res://scenes/game_objects/objects/bullets/Bullet.tscn")

signal shoot_ready()
signal shot()
signal on_ammo_change(value, max_value)


export var damage := 5.0
export var rate_of_fire := 60.0

export var max_ammo := 100
export var ammo := 50

export var bullet_speed := 20.0

var owned = false

var ready_to_shoot := true


# Called when the node enters the scene tree for the first time.
func _ready():
	
	emit_signal("on_ammo_change", ammo, max_ammo)
	
	$RateOfFireTimer.wait_time = 60 / rate_of_fire
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func reload(value) -> bool:
	
	if ammo >= max_ammo:
		return false
	
	ammo += value
	if ammo > max_ammo:
		ammo = max_ammo
	emit_signal("on_ammo_change", ammo, max_ammo)
	return true


func shoot() -> bool:
	
	if ammo <= 0 or not ready_to_shoot: 
		return false
	
	var direction : Vector3 = ($Muzzle.global_transform.origin - $Muzzle.global_transform.translated( Vector3.FORWARD ).origin).normalized()
	
	
	var position : Vector3 = $Muzzle.global_transform.origin + direction
	
	var root_node := get_tree().get_root().get_child(0)
	
	var bullet = Bullet.instance()
	bullet.set_damage(self.damage)
	bullet.set_source(null)
	root_node.add_child(bullet)
	
	var rotTransform = bullet.global_transform.looking_at(direction, Vector3.UP)
	var thisRotation = Quat(global_transform.basis).slerp(rotTransform.basis, 1)
	bullet.global_transform = Transform(thisRotation, position)
	
	bullet.velocity = direction * 20

	$AnimationPlayer.play("shoot")
	
	
	emit_signal("shot")
	
	ammo -= 1
	
	emit_signal("on_ammo_change", ammo, max_ammo)
	
	ready_to_shoot = false
	$RateOfFireTimer.start()
	
	return true






func _on_RateOfFireTimer_timeout():
	
	ready_to_shoot = true
	
	emit_signal("shoot_ready")
	
	pass # Replace with function body.

extends Spatial

var Bullet = preload("res://objects/bullets/Bullet.tscn")


signal on_ammo_change

export var damage := 5.0
export var rate_of_fire := 60.0

export var max_ammo := 100
export var ammo := 50

export var bullet_speed := 20

var owned = false

var ready_to_shoot := true

func reload(value):
	ammo += value
	if ammo > max_ammo:
		ammo = max_ammo
	emit_signal("on_ammo_change", ammo, max_ammo)

func shoot() -> bool:
	
	if ammo <= 0 or not ready_to_shoot: 
		return false
	
	var direction = ($Muzzle.global_transform.origin - $Muzzle.global_transform.translated( Vector3.FORWARD ).origin).normalized()
	
	
	var position = $Muzzle.global_transform.origin
	
	var bullet = Bullet.instance()
	bullet.damage = self.damage
	bullet.speed = self.bullet_speed
	
	var rotTransform = bullet.global_transform.looking_at(direction, Vector3.UP)
	var thisRotation = Quat(global_transform.basis).slerp(rotTransform.basis, 1)
	bullet.global_transform = Transform(thisRotation, position)
	
	bullet.velocity = direction * 20
	
	var root_node = get_tree().get_root().get_child(0)
	
	root_node.add_child(bullet)
	
	$AnimationPlayer.play("shoot")
	
	ammo -= 1
	
	emit_signal("on_ammo_change", ammo, max_ammo)
	
	ready_to_shoot = false
	$RateOfFireTimer.start()
	
	return true



# Called when the node enters the scene tree for the first time.
func _ready():
	
	emit_signal("on_ammo_change", ammo, max_ammo)
	
	$RateOfFireTimer.wait_time = 60 / rate_of_fire
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_RateOfFireTimer_timeout():
	
	ready_to_shoot = true
	
	pass # Replace with function body.

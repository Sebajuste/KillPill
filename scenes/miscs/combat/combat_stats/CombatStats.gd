class_name CombatStats
extends Node


signal damage_taken(damage)
signal health_changed(new_value, old_value)
signal health_depleted()


export var max_health: int = 100 setget set_max_health
export var invincible := false

var health: int = max_health setget set_health



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func take_damage(hit) -> void:
	if health == 0 or invincible:
		return
	
	var new_health = health - hit.damage
	print("[%s] Manage health : " % owner.name, new_health)
	if Network.is_enabled():
		if is_network_master():
			rpc("set_health", new_health)
			set_health(new_health)
	else:
		set_health(new_health)


func heal(value: int) -> void:
	var new_health = health + value
	print("[%s] Manage health : " % owner.name, new_health)
	if Network.is_enabled():
		if is_network_master():
			rpc("set_health", new_health)
			set_health(new_health)
	else:
		set_health(new_health)


func set_max_health(value: int) -> void:
	if value == null:
		return
	max_health = max(1, value)


puppet func set_health(value: int):
	var old_health = health
	health = value
	emit_signal("damage_taken", old_health - health)
	health = clamp(health, 0, max_health)
	emit_signal("health_changed", health, old_health)
	if health == 0:
		emit_signal("health_depleted")

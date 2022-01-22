tool
class_name HitBox
extends Area


export var combat_stats_path: NodePath
export var particles_scene : PackedScene


onready var combat_stats := get_node(combat_stats_path)


var player


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(owner, "ready")
	player = owner


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func on_damage(damage_source: DamageSource):
	
	if owner.is_a_parent_of(damage_source):
		return
	
	print("[%s] damaged by %s" % [owner.name, damage_source.owner.name] )
	
	if Network.enabled:
		rpc("_on_damage", damage_source.damage)
	else:
		_on_damage(damage_source.damage)
	
	damage_source.emit_signal("hit", self)


master func _on_damage(damage):
	var hit: = Hit.new(damage)
	if combat_stats and combat_stats.has_method("take_damage"):
		combat_stats.take_damage(hit)
	if Network.enabled:
		rpc("_on_hit")
	_on_hit()


puppet func _on_hit():
	
	if particles_scene:
		var particles = particles_scene.instance()
		particles.transform.origin = global_transform.origin
		get_tree().get_root().add_child(particles)
	


func _get_configuration_warning() -> String:
	
	return "Missing CombatStats node" if not combat_stats_path else ""
	

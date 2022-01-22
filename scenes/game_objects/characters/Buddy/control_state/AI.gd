extends PlayerState


signal on_actions_done
signal on_move_reached(result)


onready var goap_state_machine = $GoapSM

onready var goap = $GoapSM/Goap

onready var goap_planner = $GoapPlanner

var boid_config : BoidConfig
var enable_boid := false


var enable_target := false
var target_ref := weakref(null)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func physics_process(delta):
	
	if enable_boid:
		var boid_self := Boid3D.new(player.get_velocity(), player.global_transform.origin)
		
		var boids := Array()
		for ennemy in player.ennemies:
			boids.append( Boid3D.new(ennemy.get_velocity(), ennemy.global_transform.origin) )
		
		var move_direction := boid_self.calculate_move_direction(boids, boid_config)
		
		goap.move_target = player.global_transform.origin + move_direction * 4
	
	if enable_target:
		_update_look_position()
	
	pass


func enter(_message : Dictionary = {}):
	
	goap_state_machine.enabled = true
	goap_state_machine.transition_to("Goap/Idle")


func exit():
	
	goap_state_machine.enabled = false
	


func get_look_position() -> Vector3:
	if goap.looking:
		return goap.look_target
	var velocity = player.get_velocity()
	return player.global_transform.origin + Vector3(velocity.x, 0.0, velocity.z)
	


func get_move_target() -> Vector3:
	if goap.moving:
		return goap.move_target
	return player.global_transform.origin


func _update_look_position():
	
	var target : Spatial = target_ref.get_ref() 
	
	if target == null:
		enable_target = false
		return
	
	var target_position = target.global_transform.origin
	
	# TODO : get weapon's projectile speed
	var projectile_speed := 20.0
	
	var shoot_position := Aiming.find_aiming_position(
		player.global_transform.origin, 
		target_position,
		target.get_velocity(),
		projectile_speed
	)
	
	goap.look_target = shoot_position
	

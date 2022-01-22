tool
class_name Player
extends KinematicBody


const PillExplosion = preload("res://effects/explosions/PillExplosion.tscn")

const CatchableObject = preload("res://scenes/game_objects/gameplay/catchable_object/CatchableObject.tscn")



signal on_health_change(value, max_value)
signal on_drop_object(object)
signal on_take_object(object)
signal on_hold_object(object)
signal on_death(object)
signal ennemy_detected(player, ennemy)

export var team : String = "Team_0"

export var max_health := 100
export var invincible := false setget set_invincible

export(String, "Blue", "Red", "Yellow", "Green") var color setget set_color

export(String, "None", "AI", "Player") var handler := "None" setget set_handler



onready var skin := $Skin

onready var avoid_obstacle_ray := $AvoidObstacle

onready var control_state_machine := $ControlSM
onready var locomoton_state_mahcine := $LocomotionSM

onready var combat_stats : CombatStats = $CombatStats


var dead = false

var ennemies := []


# Called when the node enters the scene tree for the first time.
func _ready():
	
	combat_stats.max_health = max_health
	$Overlay/HealthProgressBar._on_Buddy_on_health_change(combat_stats.health, combat_stats.max_health)
	
	set_color(color)
	set_handler(handler)
	
	emit_status()
	


func set_handler(value):
	handler = value
	if control_state_machine == null:
		return
	match handler:
		"None":
			control_state_machine.transition_to("Control/None")
		"AI":
			control_state_machine.transition_to("Control/AI")
		"Player":
			control_state_machine.transition_to("Control/Player")


#
# Functions for objects manipulation
#
func has_object() -> bool:
	
	return $Skin/BodyRightHand/RightHand.get_child_count() > 0
	


func get_object():
	if has_object():
		return $Skin/BodyRightHand/RightHand.get_child(0)
	return null


func is_holding() -> bool:
	
	return $HoldPosition.get_child_count() > 0
	


#
# See weakref
#
# https://godotengine.org/qa/3645/previously-freed-instance-error
#
func take_object(object_container) -> bool:
	if not has_object() and object_container != null and object_container.has_object():
		var object = object_container.take_object()
		$Skin/BodyRightHand/RightHand.add_child(object)
		object.owned = true
		$PickUpSound.play()
		emit_signal("on_take_object", object)
		return true
	return false


func drop_object():
	if has_object():
		var object = $Skin/BodyRightHand/RightHand.get_child(0)
		$Skin/BodyRightHand/RightHand.remove_child(object)
		
		var catchable_object = CatchableObject.instance()
		catchable_object.set_object(object)
		
		Game.add_node_in_level(catchable_object)
		
		var dir = (-$HoldPosition.global_transform.basis.z + Vector3.UP).normalized()
		var throw_force := 4.0
		catchable_object.global_transform = Transform(global_transform.basis, global_transform.origin + dir)
		
		catchable_object.apply_central_impulse(dir * throw_force + get_velocity() )
		
		object.owned = false
		emit_signal("on_drop_object", object)


func hold_object(object) -> bool:
	
	if not is_holding() and object.is_in_group("catchable"):
		
		if self.global_transform.origin.distance_squared_to(object.global_transform.origin) < 1.5*1.5 and object.hold(self):
			object.get_parent().remove_child(object)
			object.transform.origin = Vector3.ZERO
			object.transform.basis = Basis()
			$HoldPosition.add_child(object)
			
			skin.play_animation("catch_object")
			
			emit_signal("on_hold_object", object)
			
			return true
	
	return false


func get_holded() -> Node:
	if is_holding():
		return $HoldPosition.get_child(0)
	return null


func release_hold() -> bool:
	
	if is_holding():
		
		var object = $HoldPosition.get_child(0)
		
		$HoldPosition.remove_child(object)
		
		#var root = get_tree().get_root().get_node("Game")
		#get_parent().add_child(object)
		
		Game.add_node_in_level(object)
		
		var dir = (-$HoldPosition.global_transform.basis.z + Vector3.UP).normalized()
		var throw_force := 4.0
		object.global_transform = Transform(global_transform.basis, global_transform.origin + dir)
		object.release()
		
		object.apply_central_impulse(dir * throw_force + get_velocity() )
		
		skin.play_animation("release_object")
		
		return true
	
	return false


"""
Action functions
"""
func shoot() -> bool:
	
	if not is_holding():
		var right_hand = $Skin/BodyRightHand/RightHand
		if right_hand.get_child_count() > 0:
			var weapon = right_hand.get_child(0)
			return weapon.shoot()
	else:
		print("[%s] Cannot shoot. He is holding box !" % get_name() )
	return false


func have_weapon() -> bool:
	if not is_holding():
		var right_hand = $Skin/BodyRightHand/RightHand
		if right_hand.get_child_count() > 0:
			var object = right_hand.get_child(0)
			return object.is_in_group("weapon")
	return false


func get_weapon() -> Node:
	var right_hand = $Skin/BodyRightHand/RightHand
	return right_hand.get_child(0)


func punch() -> bool:
	if not is_holding():
		skin.play_animation("punch")
		return true
	return false


func catch_front() -> bool:
	
	for area in $CatchArea.get_overlapping_areas():
		if area.is_in_group("catchable"):
			if take_object(area):
				return true
	
	for object in $CatchArea.get_overlapping_bodies():
		if not is_holding() and object.is_in_group("catchable"):
			if hold_object(object):
				return true
	
	return false
	


#
# Action to build and drop box on constructor
#
func use_front() -> bool:
	
	var areas = $CatchArea.get_overlapping_areas()
	
	if is_holding():
		
		var object = $HoldPosition.get_child(0)
		
		if not areas.empty():
			var area = areas[0]
			return constructor_put_box(area, object)
	
	for area in areas:
		if constructor_build(area):
			return true
	
	return false


func constructor_build(constructor) -> bool:
	if constructor.is_in_group("constructor") and constructor.team == team:
		constructor.build()
		return true
	return false


func constructor_put_box(constructor, box) -> bool:
	
	if constructor.is_in_group("constructor") and constructor.team == team:
		$HoldPosition.remove_child(box)
		
		
		var added = constructor.add_object($CatchArea, box)
		
		#var added = get_current_handler().add_object_to_constructor(box, constructor)
		
		if added:
			skin.play_animation("release_object")
			return true
		else:
			$HoldPosition.add_child(box)
		
	return false


func stop_move():
	
	$ControlSM/Control/AI/GoapSM.transition_to("Goap/Idle")
	
	pass


func heal(value):
	
	combat_stats.heal(value)
	


func set_color(value):
	
	color = value
	
	if get_node("Skin/Body/Body") == null:
		return
	
	match color:
		"Blue":
			var material = load("res://scenes/game_objects/characters/Buddy/BodyBlue.material")
			$Skin/Body/Body.set_surface_material(0, material)
		"Red":
			var material = load("res://scenes/game_objects/characters/Buddy/BodyRed.material")
			$Skin/Body/Body.set_surface_material(0, material)
		"Yellow":
			var material = load("res://scenes/game_objects/characters/Buddy/BodyYellow.material")
			$Skin/Body/Body.set_surface_material(0, material)
		"Green":
			var material = load("res://scenes/game_objects/characters/Buddy/BodyGreen.material")
			$Skin/Body/Body.set_surface_material(0, material)


func set_invincible(value):
	invincible = value
	$CombatStats.invincible = value


func emit_status():
	
	#emit_signal("on_health_change", health, max_health)
	pass


func get_velocity():
	
	return $LocomotionSM/Locomotion.velocity
	



func _on_EnnemyDetection_body_entered(character):
	
	if not ennemies.has(character) and character.team != self.team:
		ennemies.append(character)
		
		emit_signal("ennemy_detected", self, character)
		
	

func _on_EnnemyDetection_body_exited(character):
	
	var index = ennemies.find( character )
	if index != -1:
		ennemies.remove(index)
	

func _on_CombatStats_health_changed(new_value, old_value):
	
	if new_value < old_value:
		skin.play_animation("hit")
	
	$Overlay/HealthProgressBar._on_Buddy_on_health_change(new_value, combat_stats.max_health)
	
	emit_signal("on_health_change", new_value, combat_stats.max_health)
	
	pass # Replace with function body.


func _on_CombatStats_health_depleted():
	
	dead = true
	
	release_hold()
	drop_object()
	
	var explosion = PillExplosion.instance()
	get_parent().add_child(explosion)
	explosion.global_transform.origin = self.global_transform.origin
	explosion.color = color
	emit_signal("on_death", self)
	queue_free()
	

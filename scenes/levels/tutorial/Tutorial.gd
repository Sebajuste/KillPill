extends Level


const STEPS = [
	{"title": "tuto_step_move", "message": "tuto_step1_message"},
	{"title": "tuto_step_build", "message": "tuto_step2_message"},
	{"title": "tuto_step_build", "message": "tuto_step3_message"},
	{"title": "tuto_step_armed", "message": "tuto_step4_message"},
	{"title": "tuto_step_armed", "message": "tuto_step5_message"},
	{"title": "tuto_step_fight", "message": "tuto_step6_message"},
	{"title": "tuto_step_fight", "message": "tuto_step7_message"},
	{"title": "tuto_step_brotherhood", "message": "tuto_step8_message"},
	{"title": "tuto_step_brotherhood", "message": "tuto_step9_message"},
]

var next_step_index = 0


onready var level = $Level


"""
func get_player_team_member():
	return $Characters/Player
"""

func show_next_step(clear_previous := true):
	
	var step = STEPS[next_step_index]
	
	if clear_previous:
		$Notifications.clear()
	$Notifications.create_notification(tr(step.title), tr(step.message), {"hide_close_button": true})
	
	if next_step_index < STEPS.size():
		next_step_index += 1


func show_current_step():
	
	
	pass


func disable_lights():
	for lights in $Level/Lights.get_children():
		lights.visible = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("menu"):
		$InGameMenu.toggle()
	


func init(context : Dictionary = {}):
	.init(context)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	disable_lights()
	show_next_step()
	
	level.get_node("Lights/SpotStep1").visible = true
	



"""
First Step
"""
func _on_MarkArray_body_entered(body):
	$Helper/MarkArray.visible = false
	$Level/BoxEmitter.max_box = 1
	$Level/BoxEmitter.enabled = true
	disable_lights()
	$Level/Lights/SpotStep2.visible = true
	show_next_step()

"""
Second Step
"""
var _first_hold = true

func _on_Player_on_hold_object(object):
	if _first_hold:
		_first_hold = false
		disable_lights()
		$Level/Lights/SpotStep3.visible = true
		show_next_step()
		$Notifications.create_notification(tr("tuto_tips"), tr("tuto_tips_drop"))

"""
Third Step
"""
var _first_add_box := true

func _on_Constructor_on_add_box():
	
	if _first_add_box:
		_first_add_box = false
		show_next_step()
	
	pass # Replace with function body.

"""
Fourth Step
"""
var _first_gun := true

var _first_pill := true

func _on_Constructor_on_build(name, object):
	
	match name:
		"gun":
			if _first_gun:
				_first_gun = false
				show_next_step()
				$Notifications.create_notification(tr("tuto_tips"), tr("tuto_tips_ammo"))
				$Characters/BuddyIA.visible = true
		"pill":
			if _first_pill:
				_first_pill = false
				show_next_step()
				disable_lights()
				$Level/LastStepBarrier.queue_free()
				$Level/BoxEmitterFight.max_box = 15
			
			for character in get_node("Characters").get_children():
				
				if character.team == "Team_0":
					var goap_planner = character.get_node("AIHandler/GoapPlanner")
					if goap_planner != null:
						goap_planner.goal_state = {"have_weapon": true, "attack": true}
					
				
			
	


"""
Step
"""
var _first_weapon_take := true

func _on_Player_on_take_object(object):
	
	if _first_weapon_take:
		_first_weapon_take = false
		show_next_step()
		$Notifications.create_notification(tr("tuto_tips"), tr("tuto_tips_aiming") )
		disable_lights()
		$Level/Lights/SpotStep4.visible = true
	
	$PlayerUI._on_Player_on_take_object(object)
	

"""
Step
"""
func _on_BuddyTarget_on_death(character):
	
	print("_on_BuddyTarget_on_death")
	
	show_next_step()
	$Notifications.create_notification(tr("tuto_tips"), tr("tuto_tips_ammo") )
	
	disable_lights()
	$Level/Lights/SpotStep5.visible = true
	$Level/Lights/SpotStep5Bis.visible = true
	
	$Characters/BuddyBounce.visible = true
	

"""
Step
"""
func _on_BuddyBounce_on_death(character):
	
	show_next_step()
	$Level/BoxEmitter.max_box = 5
	disable_lights()
	$Level/Lights/SpotStep2.visible = true
	$Level/Lights/SpotStep3.visible = true
	


var target_destroyed = 0

func _on_BuddyIA_on_death(character):
	
	target_destroyed += 1
	
	if target_destroyed >= 2:
		$GameOver.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	


func _on_FightTrigger_area_entered(area):
	
	print("_on_FightTrigger_area_entered")
	
	for character in get_node("Characters").get_children():
		if character.has_method("character"):
			character.move_cancel()
			pass
	


func _on_InGameMenu_on_close():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	

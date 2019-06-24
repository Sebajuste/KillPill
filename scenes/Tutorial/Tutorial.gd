extends Node


const STEPS = [
	{"title": "Déplacement", "message": "Allez au marqueur vert au délà du pont. Utilisez les touches Z Q S D et la souris, ou le joystick gauche de la manette Xbox"},
	{"title": "Construction", "message": "Pour construire, il faut empiler des caisses. Approchez vous d'une caisse et appuyer sur la touche E, ou le bouton Xbox A"},
	{"title": "Construction", "message": "Placez maintenant la caisse sur la zone de construction. Placer la caisse au dessus puis appuyez sur la touche E, ou le bouton Xbox A"},
	{"title": "S'armer", "message": "Avec une caisse de posée, vous pouvez créer une arme ! Approchez vous de la zone de construction et appuyer toujours sur la touche E, ou le bouton Xbox A..."},
	{"title": "S'armer", "message": "Prenez l'arme ! Encore une fois... touche E, ou bouton Xbox A..."},
	{"title": "Combattre", "message": "Utilisons cette nouvelle arme sur l'ennemi qui vient d'apparaitre ! Appuyez sur le bouton de la souris gauche, ou la gachette Xbox droite"},
	{"title": "Combattre", "message": "Le deuxième ennemi semble hors de portée... Utilisez les rebonds à bon escient pour l'atteindre"},
	{"title": "S'accompagner", "message": "Se battre avec des coéquipier, c'est mieux ! Pour créer un bot de votre équipe, construisez en alignant deux caisses cote à coté sur la plateforme de construction"},
	{"title": "S'accompagner", "message": "Suivez votre nouvel ami, et allez EXPLOSER l'équipe adverse !"},
]

var next_step_index = 0


func show_next_step(clear_previous := true):
	
	var step = STEPS[next_step_index]
	
	if clear_previous:
		$Notifications.clear()
	$Notifications.create_notification(step.title, step.message, {"hide_close_button": true})
	
	if next_step_index < STEPS.size():
		next_step_index += 1


func show_current_step():
	
	
	pass


func disable_lights():
	
	for lights in $Environment/Lights.get_children():
		lights.visible = false


# Called when the node enters the scene tree for the first time.
func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	disable_lights()
	show_next_step()
	
	$Environment/Lights/SpotStep1.visible = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

"""
First Step
"""
func _on_MarkArray_body_entered(body):
	$Helper/MarkArray.visible = false
	$Environment/BoxEmitter.max_box = 1
	disable_lights()
	$Environment/Lights/SpotStep2.visible = true
	show_next_step()

"""
Second Step
"""
var _first_hold = true

func _on_Player_on_hold_object(object):
	if _first_hold:
		_first_hold = false
		disable_lights()
		$Environment/Lights/SpotStep3.visible = true
		show_next_step()
		$Notifications.create_notification("Astuce", "Vous pouvez à tout moment lacher la caisse en appuyant sur la touche A, ou le bouton Xbox Y")

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
				$Notifications.create_notification("Astuce", "Si vous n'avez plus de munition, détruisez une caisse ! Approchez vous, et donner un coup de poing avec le bouton droit de la souris")
				$Characters/BuddyIA.visible = true
		"pill":
			if _first_pill:
				_first_pill = false
				show_next_step()
				disable_lights()
				$Environment/LastStepBarrier.queue_free()
				$Environment/BoxEmitterFight.max_box = 15
			
			for character in get_node("Characters").get_children():
				
				if character.team == "Team_0":
					var goap_planner = character.get_node("GoapPlanner")
					if goap_planner != null:
						goap_planner.goal_state = {"attack": true}
					
				
			
	


"""
Step
"""
var _first_weapon_take := true

func _on_Player_on_take_object(object):
	
	if _first_weapon_take:
		_first_weapon_take = false
		show_next_step()
		disable_lights()
		$Environment/Lights/SpotStep4.visible = true
	

"""
Step
"""
func _on_BuddyTarget_on_death():
	
	show_next_step()
	$Notifications.create_notification("Astuce", "Si vous n'avez plus de munition, détruisez une caisse ! Approchez vous, et donner un coup de poing avec le bouton droit de la souris")
	
	disable_lights()
	$Environment/Lights/SpotStep5.visible = true
	$Environment/Lights/SpotStep5Bis.visible = true
	

"""
Step
"""
func _on_BuddyBounce_on_death():
	
	show_next_step()
	$Environment/BoxEmitter.max_box = 5
	disable_lights()
	$Environment/Lights/SpotStep2.visible = true
	$Environment/Lights/SpotStep3.visible = true
	


var target_destroyed = 0

func _on_BuddyIA_on_death():
	
	target_destroyed += 1
	
	if target_destroyed >= 2:
		$GameOver.visible = true
	


func _on_FightTrigger_area_entered(area):
	
	print("_on_FightTrigger_area_entered")
	
	for character in get_node("Characters").get_children():
		if character.has_method("character"):
			character.cancel_move()
			pass
	
	pass # Replace with function body.

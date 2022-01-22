extends PlayerState


const ACTION_TIMEOUT := 3000
const TOTAL_ACTION_TIMEOUT := 5000

var action_list := Array()


var in_process := false

var action_time := 0
var total_action_time := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func physics_process(delta):
	
	if not action_list.empty() and not in_process:
		
		in_process = true
		
		var action = action_list.pop_front()
		
		print("[Animation] START action : ", action.name)
		action_time = OS.get_ticks_msec()
		var result = action.execute( player )
		
		if typeof(result) == TYPE_BOOL and result:
			pass
		elif (typeof(result) == TYPE_BOOL and not result) or not result or not yield(action, "on_action_end"):
			state_machine.transition_to("Goap/Idle")
			in_process = false
			print("[Animation] END action : ", result)
			return
		
		if action_list.empty():
			state_machine.emit_signal("on_actions_done", get_parent())
		
		print("[Animation] END action in ", OS.get_ticks_msec() - action_time, " ms")
		
		
		if (OS.get_ticks_msec() - action_time) >= ACTION_TIMEOUT or (OS.get_ticks_msec() - total_action_time) >= TOTAL_ACTION_TIMEOUT:
			print("> Need to refresh plan")
			state_machine.transition_to("Goap/Idle") # Need to refresh action plan
		
		in_process = false
	elif not in_process:
		print("No action plan")
		state_machine.transition_to("Goap/Idle")
	


func enter(message : Dictionary = {}):
	total_action_time = OS.get_ticks_msec()
	action_list = message.action_list
	

extends Level


#onready var player_team = get_node("Teams/TeamBlue")


#var player_team_member


#var game : Game



# Called when the node enters the scene tree for the first time.
func _ready():
	
	NavigationManager.navigation = $Navigation
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	pass


func init(context : Dictionary = {}):
	.init(context)
	
	pass


"""
func find_team(character):
	for team in $Teams.get_children():
		if team.team == character.team:
			return team
	return null
"""

"""
func switch_player(old_char, new_char):
	
	if old_char:
		old_char.handler = "AI"
		old_char.disconnect("on_death", self, "_on_Player_on_death")
		old_char.disconnect("on_take_object", $PlayerUI, "_on_Player_on_take_object")
		old_char.disconnect("on_drop_object", $PlayerUI, "_on_Player_on_drop_object")
		old_char.disconnect("on_health_change", $PlayerUI, "_on_Player_on_health_change")
	
	new_char.handler = "Player"
	
	new_char.connect("on_death", self, "_on_Player_on_death")
	new_char.connect("on_take_object", $PlayerUI, "_on_Player_on_take_object")
	new_char.connect("on_drop_object", $PlayerUI, "_on_Player_on_drop_object")
	new_char.connect("on_health_change", $PlayerUI, "_on_Player_on_health_change")
	
	player_team_member = new_char
	
	$Environment/CameraRig.target = new_char
	
	new_char.emit_status()
	
	pass
"""

"""
func _on_Player_on_death(player):
	
	var team_player = find_team(player)
	
	var next_character = team_player.get_next_member(player)
	
	if next_character:
		switch_player(null, next_character)
	else:
		$GameOver.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
"""

"""
func _on_InGameMenu_on_close():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	


func _on_object_emitted(object):
	
	game.add_node_in_level(object)
	
"""

extends Node

onready var player_team = get_node("Teams/TeamBlue")

var player_team_member



# Called when the node enters the scene tree for the first time.
func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	for team in $Teams.get_children():
		
		if team == player_team:
			player_team_member = team.get_team().front()
			player_team_member.handler = "Player"
			
		else:
			team.get_team().front().handler = "AI"
	
	
	switch_player(null, $Characters/Player )
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("menu"):
		$InGameMenu.toggle()
	
	if Input.is_action_just_pressed("switch_next_team_member"):
		
		var next_member = player_team.get_next_member(player_team_member)
		print("next_member: ", next_member)
		
		if next_member != null and next_member != player_team_member:
			switch_player(player_team_member, next_member)
			
		
		pass
	
	if Input.is_action_just_pressed("switch_previous_team_member"):
		
		var previous_member = player_team.get_previous_member(player_team_member)
		print("previous_member: ", previous_member)
		
		if previous_member != null and previous_member != player_team_member:
			switch_player(player_team_member, previous_member)
		
		pass
	
	var team_dead_count = 0
	
	for teams in $Teams.get_children():
		if teams.get_team().empty():
			team_dead_count += 1
	
	if team_dead_count == 2:
		$GameOver.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func get_player_team_member():
	return player_team_member


func find_team(character):
	for team in $Teams.get_children():
		if team.team == character.team:
			return team
	return null


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
	
	new_char.emit_status()
	
	pass


func _on_Player_on_death(player):
	
	var team_player = find_team(player)
	
	var next_character = team_player.get_next_member(player)
	
	if next_character:
		switch_player(null, next_character)
	else:
		$GameOver.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	


func _on_InGameMenu_on_close():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	

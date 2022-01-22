extends Node


const PILL_SCENE = preload("res://scenes/game_objects/characters/Buddy/Buddy.tscn")
const TEAM_SCENE = preload("res://scenes/miscs/team/Team.tscn")


#onready var player_team = get_node("Teams/TeamBlue")

var player_team
var player_team_member


# Called when the node enters the scene tree for the first time.
func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	
	Game.connect("level_node_created", self, "_on_level_node_created")
	
	#player_team_member = $Level/Player
	
	#switch_player(null, player_team_member)
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var team_dead_count = 0
	
	for teams in $Teams.get_children():
		if teams.get_team().empty():
			team_dead_count += 1
	
	if team_dead_count == 2:
		$GameOver.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	


func _unhandled_input(event):
	
	if event.is_action_pressed("menu"):
		var visible = $InGameMenu.toggle()
		if visible:
			get_tree().paused = true
		else:
			get_tree().paused = false
	
	if event.is_action_pressed("switch_next_team_member"):
		var next_member = player_team.get_next_member(player_team_member)
		if next_member != null and next_member != player_team_member:
			switch_player(player_team_member, next_member)
		pass
	
	if event.is_action_pressed("switch_previous_team_member"):
		var previous_member = player_team.get_previous_member(player_team_member)
		if previous_member != null and previous_member != player_team_member:
			switch_player(player_team_member, previous_member)
		pass
	


func init(context : Dictionary):
	
	print("Solo::init -> ", context)
	
	
	#var player_team = context.player_team
	
	for team_name in context.teams:
		
		var team = TEAM_SCENE.instance()
		team.team = team_name
		team.color = team_name
		
		$Teams.add_child(team)
		
		var pill = PILL_SCENE.instance()
		pill.team = team_name
		pill.color = team_name
		
		pill.transform.origin = get_start_position(team_name)
		
		if team_name == context.player_team:
			pill.handler = "Player"
			player_team = team
			switch_player(null, pill)
		else:
			pill.handler = "AI"
		
		$Level.add_child(pill)
		
		pass
	
	
	
	
	pass


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
	
	$Level/CameraRig.set_target(new_char)
	
	new_char.emit_status()
	
	pass


func find_team(character) -> TeamHandler:
	for team in $Teams.get_children():
		if team.team == character.team:
			return team
	return null


func get_start_position(team : String) -> Vector3:
	var start_position_list := get_tree().get_nodes_in_group("start_position")
	for start_position in start_position_list:
		if start_position.name == team:
			return start_position.global_transform.origin
	return Vector3.ZERO


func _on_Player_on_death(player):
	
	var team_player := find_team(player)
	
	var next_character = team_player.get_next_member(player)
	
	if next_character:
		switch_player(null, next_character)
	else:
		$GameOver.visible = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	


func _on_level_node_created(node : Node):
	
	print("level_node_created")
	
	#$Level/Level01.add_child(node)
	$Level.add_child(node)
	

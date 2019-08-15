extends Camera

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var _pos_delta


var _player_ref

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_as_toplevel(true)
	
	#var player = get_tree().get_root().get_node("Game/Characters/Player")
	var player = get_tree().get_root().get_node("Game").get_player_team_member()
	
	print( get_tree().get_root().get_child(0).get_name() )
	print("player: ", player)
	
	#_player_ref = weakref( player )
	
	#_pos_delta = self.global_transform.origin - _player_ref.get_ref().global_transform.origin
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#var player = _player_ref.get_ref()
	
	var player = get_tree().get_root().get_node("Game").get_player_team_member()
	
	if player:
		self.global_transform.origin = player.global_transform.origin + Vector3(0, 8.7, 10)
	

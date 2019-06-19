extends Camera

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


var _pos_delta


var _player_ref

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_as_toplevel(true)
	
	_player_ref = weakref( get_tree().get_root().get_child(0).get_node("Characters/Player") )
	
	_pos_delta = self.global_transform.origin - _player_ref.get_ref().global_transform.origin
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var player = _player_ref.get_ref()
	if player:
		self.global_transform.origin = player.global_transform.origin + _pos_delta
	
	pass

class_name DebugStatusItem
extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


export var status_name : String = "" setget set_status_name
export var status_value : String = "" setget set_status_value



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_status_name(value):
	status_name = value
	$Name.text = value
	


func set_status_value(value):
	status_value = value
	$Value.text = value

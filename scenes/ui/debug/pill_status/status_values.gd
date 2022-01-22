class_name DebugStatusValue
extends Node


signal properties_changed(properties)

export var properties : Dictionary = {} setget set_properties


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func update():
	
	emit_signal("properties_changed", properties)
	


func set_properties(value : Dictionary):
	properties = value
	update()
	


func set_property(name : String, value):
	properties[name] = value
	update()

class_name Level
extends Node



var initialized := false


func _ready():
	if not initialized:
		yield(self, "ready")
		init()


func init(context : Dictionary = {}):
	
	initialized = true
	
	print("Level INIT OK")
	

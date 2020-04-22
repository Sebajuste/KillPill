extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var current_scene : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Loading.connect("scene_loading", self, "_on_scene_loading")
	Loading.connect("scene_load_progress", self, "_on_scene_load_progress")
	Loading.connect("scene_loaded", self, "_on_scene_loaded")
	
	Loading.load_scene("res://scenes/menus/main/MainMenu.tscn", {"switch": true} )
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func remove_current_scene():
	if current_scene:
		current_scene.queue_free()
		current_scene = null


func _on_scene_loading(scene_path, context):
	print("Loading scene [%s] " % scene_path, context)
	if not context.has("switch") or context.switch == true:
		$Loading.visible = true
		remove_current_scene()


func _on_scene_load_progress(current_stage, stage_count):
	print("Loading scene [%d / %d]" % [current_stage, stage_count])
	$Loading.set_progress(0, stage_count, current_stage)


func _on_scene_loaded(scene: Node, context: Dictionary):
	print("[%s] Scene loaded " % scene.name, context)
	$Loading.visible = false
	if context.switch:
		remove_current_scene()
		current_scene = scene
	add_child(scene)

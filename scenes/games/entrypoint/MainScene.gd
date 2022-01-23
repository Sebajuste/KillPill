extends Node


var current_scene : Node


onready var load_screen = $Loading
onready var animation = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	
	#Loading.connect("level_loading", self, "_on_level_loading")
	
	Loading.connect("global_loading", self, "_on_global_loading")
	Loading.connect("global_load_progress", self, "_on_global_load_progress")
	Loading.connect("global_loaded", self, "_on_global_loaded")
	
	#Loading.connect("scene_loaded", self, "_on_scene_loaded")
	
	# Loading.load_scene("res://scenes/menus/main/MainMenu.tscn", {"switch": true})
	Loading.load_level({
		"path": "res://scenes/menus/main/MainMenu.tscn",
	})
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func clear_scenes():
	for child in $Content.get_children():
		child.queue_free()





func _on_global_load_progress(scene_name, current_stage, stage_count):
	#print("Loading %s scene [%d / %d]" % [scene_name, current_stage, stage_count])
	load_screen.set_progress(0, stage_count, current_stage)


func _on_global_loading(loading):
	
	if loading:
		clear_scenes()
		#load_screen.visible = true
		animation.play("loading_fade_in")
	
	print("_on_global_loading : ", loading)
	


func _on_global_loaded(level_tree : Dictionary):
	
	print("_on_global_loaded ", level_tree)
	
	clear_scenes()
	
	_construct_level_tree(level_tree, self)
	
	animation.play("loading_fade_out")
	
	"""
	var root = null
	
	for instance in instance_list:
		var scene = instance.scene
		if instance.context.has("root") and instance.context.root or root == null:
			root = scene
		
		if instance.context.has("child") and instance.context.child:
			root.add_child(scene)
	
	$Content.add_child(root)
	current_scene = root
	
	print("Scenes added")
	
	for instance in instance_list:
		var scene = instance.scene
		if scene.has_method("init"):
			scene.init(instance.context)
	"""
	
	
	pass


func _construct_level_tree(tree : Dictionary, parent : Node):
	
	if tree.has("childs"):
		for child_config in tree.childs:
			_construct_level_tree(child_config, tree.scene)
	
	print("Add ", tree.scene, " to ", parent)
	print("> ", tree)
	
	if tree.has("parameters") and "parameters" in tree.scene:
		print("> set parameters")
		tree.scene.parameters = tree.parameters
	
	if parent.has_node("Content"):
		parent.get_node("Content").add_child(tree.scene)
	elif parent.has_node("Level"):
		parent.get_node("Level").add_child(tree.scene)
	else:
		parent.add_child(tree.scene)
	
	
	


extends Node


signal scene_loading(path, context)
signal scene_loaded(scene, context)
signal scene_load_progress(scene_name, current_stage, stage_count)

signal global_loading(loading)
signal global_load_progress(scene_name, current, total)
signal global_loaded(instance_list)

# var current_scene = null


var load_tree := {}

var loader_handler_list := Array()


var total_stage_count : int = 0


var loading := false


class LoaderHandler:
	var path : String
	var loader : ResourceInteractiveLoader
	var context : Dictionary
	var parent : LoaderHandler
	var poll_index : int = 0
	var completed := false
	var instance : Node
	
	func _init(_path: String, _loader : ResourceInteractiveLoader, _context := {}, _parent : LoaderHandler = null):
		self.path = _path
		self.loader = _loader
		self.context = _context
		self.parent = _parent
		self.poll_index = 0
		self.instance = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#var root = get_tree().get_root()
	#current_scene = root.get_child( root.get_child_count() -1 )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_loading():
		var loader_handler : LoaderHandler = _next_loader_handler()
		var loader : ResourceInteractiveLoader = loader_handler.loader
		var result = loader.poll()
		
		if result == OK:
			loader_handler.poll_index += 1
			emit_signal("scene_load_progress", loader_handler.path, loader_handler.poll_index, loader.get_stage_count())
		
		if result == ERR_FILE_EOF:
			loader_handler.poll_index += 1
			var resource = loader.get_resource()
			loader_handler.completed = true
			print("Scene loaded")
			var scene = resource.instance()
			loader_handler.instance = scene
			
			emit_signal("scene_loaded", loader_handler.path, scene, loader_handler.context )
			"""
			if _switch_scene:
				current_scene = scene
				get_tree().get_root().add_child( current_scene )
				get_tree().set_current_scene( current_scene )
			"""
		if result == ERR_FILE_CORRUPT:
			push_error("Error Loading file %s" % loader_handler.path )
			loader_handler.completed = true
		
		emit_signal("global_load_progress", loader_handler.path, get_total_stage_poll(), get_total_stage_count())
		
		if not is_loading():
			"""
			var instance_list := Array()
			for handler in loader_handler_list:
				if handler.instance:
					instance_list.append({
						"scene": handler.instance,
						"context": handler.context
					})
			"""
			
			add_scene_in_nodetree(load_tree)
			
			clear()
			loading = false
			
			#emit_signal("global_loaded", instance_list)
			emit_signal("global_loaded", load_tree)
			emit_signal("global_loading", loading)
		
		
	elif loading:
		push_error("Loading but no loader !")


func add_scene_in_nodetree(config : Dictionary):
	
	#config.path
	for loader_handler in loader_handler_list:
		
		if loader_handler.path == config.path:
			config.scene = loader_handler.instance
			break
		
		pass
	
	if config.has("childs"):
		for child_config in config.childs:
			add_scene_in_nodetree(child_config)
	
	pass


func get_total_stage_count() -> int:
	var total := 0
	for loader_handler in loader_handler_list:
		total += loader_handler.loader.get_stage_count()
	return total


func get_total_stage_poll() -> int:
	var total := 0
	for loader_handler in loader_handler_list:
		total += loader_handler.poll_index
	return total


func count_loading_scene() -> int:
	var total := 0
	for loader_handler in loader_handler_list:
		if not loader_handler.completed:
			total += 1
	return total


func is_loading() -> bool:
	return count_loading_scene() > 0

"""
func change_scene(path: String, context: Dictionary = {}):
	if not loading:
		loading = true
		emit_signal("global_loading", loading)
		_switch_scene = true
		call_deferred("_deferred_load_scene", path, context)


func load_scene(path: String, context: Dictionary = {}):
	loading = true
	emit_signal("global_loading", loading)
	_switch_scene = false
	_deferred_load_scene(path, context, null)
"""

func load_level(config: Dictionary):
	
	loading = true
	load_tree = config
	emit_signal("global_loading", loading)
	_load_sublevels(config)
	"""
	var loader_handler := _deferred_load_scene(config.path, config, null)
	
	if config.has("childs"):
		for child_config in config.childs:
			_deferred_load_scene(child_config.path, child_config, loader_handler)
	"""


func _load_sublevels(config : Dictionary):
	
	var path = config.path
	
	var parameters = config.parameters if config.has("parameters") else {}
	
	var loader_handler := _deferred_load_scene(config.path, parameters, null)
	
	if config.has("childs"):
		for child_config in config.childs:
			_load_sublevels(child_config)
	


func clear():
	print("Loading::clear")
	var completed_found := true
	while completed_found:
		completed_found = false
		for index in range(loader_handler_list.size()):
			var loader_handler = loader_handler_list[index]
			if loader_handler.completed:
				loader_handler_list.remove(index)
				completed_found = true
				break


func _next_loader_handler() -> LoaderHandler:
	for handler_loader in loader_handler_list:
		if not handler_loader.completed:
			return handler_loader
	return null


func _deferred_load_scene(path : String, context : Dictionary, handler_parent : LoaderHandler) -> LoaderHandler:
	var loader := ResourceLoader.load_interactive(path)
	var loader_handler := LoaderHandler.new(path, loader, context, handler_parent)
	loader_handler_list.push_back(loader_handler)
	total_stage_count += loader.get_stage_count()
	emit_signal("scene_loading", path, context)
	"""
	if _switch_scene:
		current_scene.free()
	"""
	return loader_handler

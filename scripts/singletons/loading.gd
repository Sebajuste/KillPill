extends Node

signal scene_loading(path, context)
signal scene_loaded(scene, context)
signal scene_load_progress(current_stage, stage_count)


var current_scene = null

var _loader : ResourceInteractiveLoader
var _poll_index: int

var _loading := false
var _switch_scene := false
var _loading_context: Dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if _loader != null:
		var result = _loader.poll()
		_poll_index += 1
		emit_signal("scene_load_progress", _poll_index, _loader.get_stage_count())
		if result == ERR_FILE_EOF:
			var resource = _loader.get_resource()
			_loader = null
			_poll_index = 0
			_loading = false
			var scene = resource.instance()
			emit_signal("scene_loaded", scene, _loading_context)
			if _switch_scene:
				current_scene = scene
				get_tree().get_root().add_child( current_scene )
				get_tree().set_current_scene( current_scene )
	elif _loading:
		push_error("Loading but no loader !")


func change_scene(path: String, context: Dictionary = {}):
	if not _loading:
		_loading = true
		_switch_scene = true
		_loading_context = context
		call_deferred("_deferred_load_scene", path)


func load_scene(path: String, context: Dictionary = {}):
	if not _loading:
		_loading = true
		_switch_scene = false
		_loading_context = context
		call_deferred("_deferred_load_scene", path)


func _deferred_load_scene(path):
	_poll_index = 0
	_loader = ResourceLoader.load_interactive(path)
	emit_signal("scene_loading", path, _loading_context)
	if _switch_scene:
		current_scene.free()

extends Control


const STATUS_ITEM_SCENE = preload("StatusItem.tscn")


var status_values : DebugStatusValue setget set_status_values


onready var status_name := $VBoxContainer/StatusName
onready var values_list := $VBoxContainer/Control/MarginContainer/ValuesList

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func set_status_values(value : DebugStatusValue):
	status_values = value
	status_name.text = value.name
	status_values.connect("properties_changed", self, "_on_properties_changed")
	status_values.update()


func properties_changed(properties : Dictionary):
	for property in properties:
		var item := _get_or_create_item(property)
		item.status_value = str(properties[property])


func _get_or_create_item(name : String) -> DebugStatusItem:
	
	var result : DebugStatusItem
	
	if values_list.has_node(name):
		result = values_list.get_node(name)
	else:
		result = STATUS_ITEM_SCENE.instance()
		result.name = name
		result.status_name = name
		values_list.add_child(result)
	
	return result

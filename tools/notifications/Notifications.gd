extends CanvasLayer

var Notification = preload("res://tools/notifications/Notification.tscn")

func create_notification(title: String, message: String, options = {}) -> String:
	
	var notification = Notification.instance()
	notification.title = title
	notification.message = message
	
	add_child(notification)
	
	if options.has("show_time"):
		notification.show_time = options["show_time"]
	if options.has("auto_hide"):
		notification.auto_hide = options["auto_hide"]
	
	notification.connect("on_close", self, "_on_close_notification")
	
	return notification.get_name()

func remove_notification(name: String) -> bool:
	
	var notification = $MarginContainer/VBoxContainer.get_node(name)
	
	if notification != null:
		notification.queue_free()
		return true
	return false

func _on_close_notification(notification):
	
	print("_on_close_notification: ", notification)
	
	notification.queue_free()
	

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

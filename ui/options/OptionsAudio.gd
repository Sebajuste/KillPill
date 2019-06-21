extends VBoxContainer


onready var general_slider = $HBoxContainer/General
onready var music_slider = $HBoxContainer2/Music
onready var effects_slider = $HBoxContainer3/Effects
onready var mute_checkbox = $HBoxContainer4/Mute

var general := 100
var music := 100
var sound_effects := 100
var mute := false

func reload():
	
	general = configuration.Settings.Audio.MASTER
	music = configuration.Settings.Audio.MUSIC
	sound_effects = configuration.Settings.Audio.SOUND_EFFECTS
	
	mute = configuration.Settings.Audio.MUTE
	
	
	general_slider.value = general
	music_slider.value = music
	effects_slider.value = sound_effects
	
	mute_checkbox.pressed = mute
	
	pass


func apply():
	
	configuration.Settings.Audio.MASTER = general
	configuration.Settings.Audio.MUSIC = music
	configuration.Settings.Audio.SOUND_EFFECTS = sound_effects
	
	configuration.Settings.Audio.MUTE = mute
	


# Called when the node enters the scene tree for the first time.
func _ready():
	
	reload()
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_General_value_changed(value):
	
	general = value
	

func _on_Music_value_changed(value):
	
	music = value
	

func _on_Effects_value_changed(value):
	
	sound_effects = value
	

func _on_Mute_toggled(button_pressed):
	
	mute = button_pressed
	

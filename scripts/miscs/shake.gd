class_name Shake
extends Spatial

signal ended()

export var MAX_YAW := PI / 10
export var MAX_PITCH := PI / 10
export var MAX_ROLL := PI / 10


var trauma := 0.0

var noise := OpenSimplexNoise.new()
var noise_t := 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	
	noise.period = 0.1
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if trauma == 0.0:
		return
	
	trauma = max(trauma - delta, 0.0)
	
	if trauma == 0.0:
		transform.basis = Basis()
		noise_t = 0.0
		emit_signal("ended")
		return
	
	var shake = trauma * trauma
	noise_t += delta
	
	var quat := Quat()
	noise.set_seed(0)
	quat *= Quat(Vector3.UP, MAX_YAW * shake * noise.get_noise_1d(noise_t) )
	noise.set_seed(1)
	quat *= Quat(Vector3.RIGHT, MAX_PITCH * shake * noise.get_noise_1d(noise_t) )
	noise.set_seed(2)
	quat *= Quat(Vector3.FORWARD, MAX_ROLL * shake * noise.get_noise_1d(noise_t) )
	
	transform.basis = Basis(quat)
	



func shake(value: float):
	
	trauma = clamp(value, 0.0, 1.0)
	

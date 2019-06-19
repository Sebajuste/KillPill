extends RigidBody


export var acceleration = 1.0
export var jump = 7.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _fixed_process(delta):
	
	print("_fixed_process")
	

func _integrate_forces(state):

	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# var is_on_ground = state
	
	
	
	if Input.is_action_pressed("ui_right"):
		apply_central_impulse(  Vector3.RIGHT * acceleration )
	
	if Input.is_action_pressed("ui_left"):
		apply_central_impulse( Vector3.LEFT * acceleration )
	
	if Input.is_action_pressed("ui_up"):
		apply_central_impulse( Vector3.FORWARD * acceleration )
	
	if Input.is_action_pressed("ui_down"):
		apply_central_impulse( Vector3.BACK * acceleration )
	
	if Input.is_action_just_pressed("jump") and abs(linear_velocity.y) < 0.1:
		apply_central_impulse( Vector3.UP * jump )
	
	pass




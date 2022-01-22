class_name Steering3D


const DEFAULT_MASS := 10.0





static func follow(
	velocity : Vector3,
	global_position: Vector3,
	target_position: Vector3,
	max_speed: float,
	mass : float = DEFAULT_MASS
) -> Vector3:
	var desired_velocity := (target_position - global_position).normalized() * max_speed
	var steering := (desired_velocity - velocity) / mass
	return vec3_truncate(velocity + steering, max_speed)


static func follow_with_force(
	velocity : Vector3,
	position : Vector3,
	target : Vector3,
	max_speed: float,
	force: float,
	slowing_radius := 0.5,
	mass : float = DEFAULT_MASS
) -> Vector3:
	var target_delta := target - position
	var desired_velocity : Vector3
	var target_distance = target_delta.length()
	if target_distance < slowing_radius:
		desired_velocity = target_delta.normalized() * max_speed * (target_distance / slowing_radius)
	else:
		desired_velocity = target_delta.normalized() * max_speed
	
	var steering : Vector3 = vec3_truncate(desired_velocity - velocity, force) / mass
	return vec3_truncate(velocity + steering, max_speed)


static func vec3_truncate(vector: Vector3, max_value: float):
	if vector.length_squared() > max_value * max_value:
		return vector.normalized() * max_value
	return vector

class_name Aiming




static func find_aiming_position(from: Vector3, target_position : Vector3, target_velocity : Vector3, projectile_speed : float) -> Vector3:
	
	var min_delta = null
	var shoot_pos := target_position
	
	for i in range(20):
		var t: float = i * 0.2
		
		var next_target_pos := _next_target_pos(target_position, target_velocity, t)
		var length := (from - next_target_pos).length()
		var shoot_length := projectile_speed * t
		var delta := abs(length - shoot_length)
		
		if min_delta == null or delta < min_delta:
			min_delta = delta
			shoot_pos = next_target_pos
	
	return shoot_pos


static func _next_target_pos(target_position: Vector3, velocity : Vector3, t := 1.0) -> Vector3:
	
	return target_position + (velocity * 1.0) * t
	

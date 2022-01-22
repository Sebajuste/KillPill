class_name Boid3D
extends Object


const DIRECTIONS := PoolVector3Array()

var velocity : Vector3
var position : Vector3


class Boid3DNearestResult:
	var separate : Array
	var align : Array
	var cohesion : Array
	
	func _init(separate : Array, align : Array, cohesion : Array):
		self.separate = separate
		self.align = align
		self.cohesion = cohesion


func _init(velocity : Vector3, position : Vector3):
	self.velocity = velocity
	self.position = position


func calculate_move_direction(boids : Array, config : BoidConfig) -> Vector3:
	
	var boids_result := _get_nearest_boids(boids, config)
	
	var sep := _separate(boids_result.separate)
	var ali := _align(boids_result.align, config)
	var coh := _cohesion(boids_result.cohesion, config)
	
	return sep * config.separate_weight + ali * config.align_weight + coh * config.cohesion_weight


func _get_nearest_boids(boids : Array, config : BoidConfig) -> Boid3DNearestResult:
	var separate := []
	var align := []
	var cohesion := []
	for boid in boids:
		var delta_position : Vector3 = boid.position - position
		if _is_visible(delta_position.normalized(), velocity.normalized(), config.field_of_view_rad):
			var distance = delta_position.length_squared()
			if config.separate_weight > 0.0 and distance < config.separate_distance * config.separate_distance:
				separate.push_back( boid )
			if config.align_weight > 0.0 and distance < config.align_distance * config.align_distance:
				align.push_back( boid )
			if config.cohesion_weight > 0.0 and distance < config.cohesion_distance * config.cohesion_distance:
				cohesion.push_back( boid )
	return Boid3DNearestResult.new(separate, align, cohesion)


func _separate(boids : Array) -> Vector3:
	var steer := Vector3.ZERO
	var count := 0
	
	for boid in boids:
		var delta_position : Vector3 = position - boid.position
		steer += delta_position.normalized() / delta_position.length()
		count += 1
	
	if count > 0:
		steer = steer / count
	
	return steer.normalized()


func _align(boids : Array, config : BoidConfig) -> Vector3:
	var sum := Vector3.ZERO
	var count := 0
	
	for boid in boids:
		sum += boid.velocity
		count += 1
	
	if count > 0:
		var avg = sum / count
		var desired = avg.normalized() * config.max_speed
		var steer = desired - velocity
		return steer.normalized()
	
	return Vector3.ZERO


func _cohesion(boids : Array, config : BoidConfig) -> Vector3:
	var sum := Vector3.ZERO
	var count := 0
	
	for boid in boids:
		sum += boid.position
		count += 1
	
	if count > 0:
		var target = sum / count
		var desired = (target - position).normalized() * config.max_speed
		var steer = desired - velocity
		return steer.normalized()
	
	return Vector3.ZERO


static func _is_visible(boid_direction : Vector3, move_direction : Vector3, max_angle : float = PI) -> bool:
	var dot_product := move_direction.dot(boid_direction)
	return acos(dot_product) < max_angle


static func get_ray_directions() -> PoolVector3Array:
	
	if DIRECTIONS.empty():
		
		print("Init ray directions")
		
		var numViewDirections := 200
		var goldenRatio := (1.0 + sqrt (5.0)) / 2.0;
		var angleIncrement = PI * 2.0 * goldenRatio;
		
		for i in range(numViewDirections):
			var t : float = float(i) / numViewDirections;
			var inclination = acos (1 - 2 * t);
			var azimuth = angleIncrement * i;
			
			var x = sin (inclination) * cos (azimuth);
			var y = sin (inclination) * sin (azimuth);
			var z = cos (inclination);
			DIRECTIONS.append(Vector3 (x, y, z) )
	
	return DIRECTIONS

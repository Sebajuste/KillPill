class_name BoidConfig
extends Resource


export var separate_distance : float
export var separate_weight : float = 1.0
export var align_distance : float
export var align_weight : float = 1.0
export var cohesion_distance : float
export var cohesion_weight : float = 1.0

export var max_speed : float
export var field_of_view: float = 270


var field_of_view_rad : float = 2 * PI


func _init():
	
	field_of_view_rad = deg2rad(field_of_view)
	

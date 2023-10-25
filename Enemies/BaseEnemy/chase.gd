extends State

@onready var view_radius: CollisionShape2D = $%FlockView/ViewRadius

@export var mouse_follow_force: = 0.05
@export var cohesion_force: = 0.05
@export var algin_force: = 0.05
@export var separation_force: = 0.05
@export var view_distance := 50.0
@export var avoid_distance := 20.0


var _flock: Array = []

var _velocity: Vector2

var player_direction: Vector2 = Vector2.ZERO

var max_speed: float

func enter(_msg:= {}):
	randomize()
	max_speed = owner.speed
	_velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * max_speed

func physics_update(_delta: float) -> void:
	var mouse_vector = Vector2.ZERO
	if(Global.Player != null):
		mouse_vector = owner.global_position.direction_to(Global.Player.global_position) * max_speed * mouse_follow_force
	
	# get cohesion, alginment, and separation vectors
	var vectors = get_flock_status(_flock)
	
	# steer towards vectors
	var cohesion_vector = vectors[0] * cohesion_force
	var align_vector = vectors[1] * algin_force
	var separation_vector = vectors[2] * separation_force

	var acceleration = cohesion_vector + align_vector + separation_vector + mouse_vector
	
	_velocity = (_velocity + acceleration).limit_length(max_speed)
	
	owner.set_velocity(_velocity)
	owner.move_and_slide()
	_velocity = owner.velocity
	
	owner.sprite.flip_h = _velocity.x < 0


func get_flock_status(flock: Array) -> Array[Vector2]:
	var center_vector: = Vector2()
	var flock_center: = Vector2()
	var align_vector: = Vector2()
	var avoid_vector: = Vector2()
	
	for f in flock:
		var neighbor_pos: Vector2 = f.global_position

		align_vector += f.velocity
		flock_center += neighbor_pos

		var d = owner.global_position.distance_to(neighbor_pos)
		if d > 0 and d < avoid_distance:
			avoid_vector -= (neighbor_pos - owner.global_position).normalized() * (avoid_distance / d * max_speed)
	
	var flock_size = flock.size()
	if flock_size:
		align_vector /= flock_size
		flock_center /= flock_size

		var center_dir = owner.global_position.direction_to(flock_center)
		var center_speed = max_speed * (owner.global_position.distance_to(flock_center) / view_radius.shape.radius)
		center_vector = center_dir * center_speed

	return [center_vector, align_vector, avoid_vector]



func _on_flock_view_area_entered(area: Area2D) -> void:
	if owner != area:
		_flock.append(area.get_parent())

func _on_flock_view_area_exited(area: Area2D) -> void:
	_flock.remove_at(_flock.find(area.get_parent()))

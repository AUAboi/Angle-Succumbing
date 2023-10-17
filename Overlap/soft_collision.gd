extends Area2D

func is_colliding() -> bool:
	return get_overlapping_areas().size() > 0
	
func get_push_vector() -> Vector2:
	var push_vector: Vector2 = Vector2.ZERO
	if is_colliding():
		var area: Area2D = get_overlapping_areas()[0]
		push_vector = area.global_position.direction_to(global_position)
		push_vector.normalized()
	return push_vector

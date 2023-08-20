extends Area2D

func is_colliding():
	return get_overlapping_areas().size() > 0
	
func get_push_vector():
	var push_vector: Vector2 = Vector2.ZERO
	if is_colliding():
		var area: Area2D = get_overlapping_areas()[0]
		push_vector = area.global_position.direction_to(global_position)
	return push_vector

extends State

func enter(msg:= {}):
	owner.get_node("%Hitbox/CollisionShape2D").set_deferred("disabled", true)
	if msg.has("death_animation"):
		owner.animation_player.play(msg.death_animation)

extends Pickup

func pickup(body):
	picked_up.emit()
	body.coins += 1
	particles.emitting = true

func _particles_done():
	queue_free()

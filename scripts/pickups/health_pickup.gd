extends Pickup

@export_range(1, 100) var health_bonus : int

func pickup(body):
	picked_up.emit()
	body.hp = clamp(body.hp + health_bonus, 0, body.max_hp)
	queue_free()

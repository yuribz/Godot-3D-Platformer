extends Pickup

@onready var timer = $Timer

func pickup(body):
	if visible:
		timer.start()
		picked_up.emit()
		body.jumps = 2
		visible = false
	
func respawn():
	visible = true

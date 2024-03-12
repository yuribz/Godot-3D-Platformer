extends Area3D


@onready var mesh = $Flames
@onready var timer = $Timer

var direction = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mesh.rotate_y(deg_to_rad(1))
	mesh.position.y += direction * delta

func change_direction():
	direction *= -1

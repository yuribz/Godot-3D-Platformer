class_name Pickup extends Area3D

signal picked_up
@onready var path = $Path3D/PathFollow3D
#@onready var label = $Path3D/PathFollow3D/Label3D
@onready var mesh = $Path3D/PathFollow3D/MeshInstance3D
@onready var particles = $Path3D/PathFollow3D/CPUParticles3D

var direction = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	path.progress_ratio = 0.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	mesh.rotate_y(deg_to_rad(2))
	path.progress_ratio += (delta / 2) * direction 
	if path.progress_ratio > 0.9:
		direction *= -1
	if path.progress_ratio <= 0:
		path.progress_ratio = 0
		direction = 1
		
	#label.text = str(snapped(path.progress_ratio, 0.01))

extends Node3D

signal lava
signal level_changed

@export var next_level : PackedScene
@onready var lava_area = $LevelPhysical/Lava

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func lava_hit(body):
	print("Lava!")
	lava.emit()
	
func change_level(body):
	level_changed.emit()
	queue_free()

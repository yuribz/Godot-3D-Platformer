extends Node3D

@export var first_level : PackedScene

@onready var player = $Player
@onready var level
@onready var first_level_name : String


# Called when the node enters the scene tree for the first time.
func _ready():
	level = first_level.instantiate()
	add_child(level)
	
	first_level_name = level.name
	
	level.lava.connect(player.on_lava)
	level.level_changed.connect(level_changed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_physical_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	if Input.is_physical_key_pressed(KEY_R):
		get_tree().reload_current_scene()
	
	$Label.text = str(player.coins) + "\n" + str(player.jumps)

func level_changed():
	print("Level changed successfully!")
	
	# rebind the reference to the new level
	level = level.next_level.instantiate()
	
	# add the new level, reset player's position
	add_child(level)
	get_node("Player").position = Vector3.ZERO
	
	# reconnect the signals for the new level
	level.lava.connect(player.on_lava)
	level.level_changed.connect(level_changed)

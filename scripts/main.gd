extends Node3D

@export var first_level : PackedScene

@onready var player = $Player
@onready var level
@onready var first_level_name : String
@onready var label = $HUD/coins_jumps
@onready var health_bar = $"HUD/Health Bar"
@onready var health_bar_progress = health_bar.get_node("Health Bar Progress")
@onready var window = get_tree().get_root()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	level = first_level.instantiate()
	add_child(level)
	
	first_level_name = level.name
	
	level.lava.connect(player.on_lava)
	level.level_changed.connect(level_changed)
	
	window.title = "Awesome Adventures v0.1"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	health_bar_progress.max_value = player.max_hp
	health_bar_progress.value = player.hp
	
	health_bar.get_node("HP Label").text = str(player.hp) + "/" + str(player.max_hp)
	
	if Input.is_physical_key_pressed(KEY_ESCAPE):
		get_tree().quit()
	
	if Input.is_physical_key_pressed(KEY_R):
		get_tree().reload_current_scene()
	
	label.text = "Coins: " + str(player.coins)
	label.text += "\nJumps: " + str(player.jumps)
	
	$HUD/curlevel.text = level.name

func level_changed():
	var debug_message : String = "Level changed successfully! "
	
	debug_message += level.name
	
	# rebind the reference to the new level
	level = level.next_level.instantiate()
	
	# add the new level, reset player's position
	add_child(level)
	
	debug_message += " -> " + level.name
	
	# reconnect the signals for the new level
	level.lava.connect(player.on_lava)
	level.level_changed.connect(level_changed)
	print(debug_message)

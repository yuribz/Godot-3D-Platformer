extends CharacterBody3D


const SPEED = 5.0
const BULLET_DAMAGE = 3.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var path_follow = get_parent()
@onready var bullet = preload("res://scenes/bullet.tscn")
@onready var timer = $Timer

var bullets_shot : Array

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	path_follow.progress_ratio += 0.005
	
	for bul in bullets_shot:
		
		
		bul.position.x += delta * 10
		
		if bul.position.x > 20:
			bul.queue_free()
			bullets_shot.erase(bul)

	move_and_slide()

func player_spotted(body):
	timer.start()

func shoot_bullet():
	# create new bullet and set its position to that of enemy
	var bul_instance = bullet.instantiate()
	bul_instance.position = global_position
	
	# connect the player collision signal
	bul_instance.body_entered.connect(bullet_hit)
	
	# add it to the bullet list and the tree
	bullets_shot.append(bul_instance)
	get_tree().root.add_child(bul_instance)
	

func player_left(body):
	timer.stop()
	
func bullet_hit(body):
	if body.name == "Player":
		body.get_damage(BULLET_DAMAGE)



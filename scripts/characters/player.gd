extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENS = 0.5
const TENTH_LESS = 0.9
const TENTH_MORE = 1.1
const SPRING_LENGTH_AIMING = 2
const SPRING_LENGTH_FREE = 10
enum CAMERA_MODE {FREE_VIEW, AIMING, DOWN_SIGHTS}

@onready var neck = $Neck
@onready var camera = $Neck/SpringArm3D/Camera3D
@onready var mesh = $MeshInstance3D
@onready var dmg_timer = $"Damage Timer"
@onready var dmg_overlay = preload("res://materials/damage_overlay.tres")
#@onready var level = get_parent().get_node(get_parent().first_level_name)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var jumps : int
var coins : int
var boost : float
var hp : float
var max_hp : float
var camera_mode : int

func _ready():
	jumps = 2
	coins = 0
	hp = 32
	max_hp = 32
	camera_mode = 0

func _physics_process(delta):
	# Add the gravity.
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	$MeshInstance3D.rotate_y(deg_to_rad(1))
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		jumps = 2

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and jumps > 0:
		velocity.y = JUMP_VELOCITY
		jumps -= 1
		
	if Input.is_action_pressed("sprint"):
		boost = SPEED
	else:
		boost = 0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * (SPEED + boost)
		velocity.z = direction.z * (SPEED + boost)
	else:
		velocity.x = move_toward(velocity.x, 0, (SPEED + boost))
		velocity.z = move_toward(velocity.z, 0, (SPEED + boost))
		
	if hp <= 0:
		death()
	
		
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENS))
		neck.rotate_x(deg_to_rad(-event.relative.y * SENS))
		neck.rotation.x = clamp(neck.rotation.x, -PI / 2, PI / 2)
	if event is InputEventMouseButton:
		var spring = neck.get_node("SpringArm3D")
		var clamp_length = spring.spring_length
		match event.get_button_index():
			MOUSE_BUTTON_WHEEL_UP:
				clamp_length *= TENTH_LESS
			MOUSE_BUTTON_WHEEL_DOWN:
				clamp_length *= TENTH_MORE
			MOUSE_BUTTON_MASK_RIGHT:
				if camera_mode == CAMERA_MODE.FREE_VIEW:
					camera_mode = CAMERA_MODE.AIMING
					spring.spring_length = SPRING_LENGTH_AIMING
					spring.position = Vector3(1, 0, 0)
				elif camera_mode == CAMERA_MODE.AIMING:
					camera_mode = CAMERA_MODE.FREE_VIEW
					spring.spring_length = 3
					spring.position = Vector3.ZERO
		
		if camera_mode == CAMERA_MODE.FREE_VIEW:
			spring.spring_length = clamp(clamp_length, 2, SPRING_LENGTH_FREE)
			
func on_lava():
	death()

func get_damage(damage):
	hp -= damage
	dmg_timer.start()
	mesh.material_overlay = dmg_overlay

func damage_over():
	mesh.material_overlay = null

	
func death():
	position = Vector3.ZERO
	hp = max_hp

extends CharacterBody3D 

@export var speed := 4.0
@export var crouch_speed := 2.0  # Slower movement when crouching
@export var jump_velocity := 4.5
@export var mouse_sensitivity := 0.002

@export var crouch_height := 1.0  # Height when crouching
@export var standing_height := 1.8  # Normal standing height
@export var crouch_camera_offset := -0.5  # Camera movement when crouching
@export var crouch_transition_speed := 8.0  # Speed of the transition

@export var journal_inv: JournalInventory

@onready var camera = $Camera3D
@onready var collision_shape = $CollisionShape3D

var gravity = ProjectSettings.get("physics/3d/default_gravity")
var velocity_vector := Vector3.ZERO
var is_crouching = false
var default_camera_position
var target_camera_position
var target_height

var keys_collected : int = 0 
var journal_entries_collected : int = 0 

var is_movement_enabled := true  # New variable to control movement

func freeze_movement():
	is_movement_enabled = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Show and unlock the mouse
	print("freeze called")

func unfreeze_movement():
	is_movement_enabled = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)  # Hide and lock the mouse back to the window
	print("unfreeze called")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("player")
	default_camera_position = camera.position.y
	target_camera_position = default_camera_position
	target_height = standing_height

func _input(event):
	if not is_movement_enabled:
		return
	
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)

func _physics_process(delta):
	
	if not is_movement_enabled:
		velocity.x = 0
		velocity.z = 0
		move_and_slide()
		return
		
	var input_dir = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		input_dir.z -= 1
	if Input.is_action_pressed("move_backward"):
		input_dir.z += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1

	# Handle Crouching
	if Input.is_action_pressed("crouch"):
		is_crouching = true
		speed = crouch_speed
		target_height = crouch_height
		target_camera_position = default_camera_position + crouch_camera_offset
	else:
		is_crouching = false
		speed = 4.0
		target_height = standing_height
		target_camera_position = default_camera_position

	# Smooth transition for crouching
	collision_shape.shape.height = lerp(collision_shape.shape.height, target_height, delta * crouch_transition_speed)
	camera.position.y = lerp(camera.position.y, target_camera_position, delta * crouch_transition_speed)

	input_dir = input_dir.normalized()
	var move_dir = (global_transform.basis * input_dir).normalized()
	velocity.x = move_dir.x * speed
	velocity.z = move_dir.z * speed

	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_just_pressed("jump") and not is_crouching:
		velocity.y = jump_velocity  # Prevent jumping while crouching

	move_and_slide()

# Function to collect a key
func add_key():
	keys_collected += 1
	print("Key collected! Total keys:", keys_collected)
	
func add_journalentry(item):
	journal_entries_collected += 1
	print("Journal entry collected! Total entries:", journal_entries_collected)
	journal_inv.insert(item)

# Function to use a key
func use_key(amount: int) -> bool:
	if keys_collected >= amount:  # Check if the player has enough keys
		keys_collected -= amount  # Subtract the used keys
		print("Key used! Keys left:", keys_collected) 
		return true  # Successfully used a key
	else:
		print("You don’t have a key")
		return false  # Not enough keys to use

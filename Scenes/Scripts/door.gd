extends StaticBody3D

@export var required_keys : int = 1  # How many keys are needed to open the door
var is_open = false  # Tracks if the door is already open

@export var swing_angle : float = 90.0  # Angle to which the door will swing
@export var swing_duration : float = 1.0  # Duration of the swing animation (in seconds)

@onready var animation_player = $AnimationPlayer  # The AnimationPlayer node

func _ready():
	add_to_group("interactable")  # So the player’s raycast can detect it

func on_interact():
	# Get the player node (same method as before)
	var player = get_node("/root/Node3D/Player/Player")  # Adjust path if necessary

	# Check if the player exists and has the 'use_key' function
	if player and player.has_method("use_key"):
		if player.use_key(1):  # Try to use 1 key
			open_door()
		else:
			print("Door is locked! You need a key.")

# Function to animate the door swinging open
func open_door():
	print("Key used! Door is opening!")  # Key used message
	# Play the door opening animation
	animation_player.play("OpenDoor")

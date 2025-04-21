extends StaticBody3D  # Or KinematicBody3D, depending on your setup

@export var pickup_distance = 5.0  # Distance at which the player can interact with the key
@onready var player = $"/root/Player"  # Replace this path with your player's path in the scene

var is_picked_up = false

# Called every frame to check the player's distance to the key
func _process(delta):
	if not is_picked_up and player and player.position.distance_to(global_position) <= pickup_distance:
		# Check if the player is within range of the key
		if Input.is_action_just_pressed("ui_interact"):  # Make sure this is set up in your Input Map
			pickup_key()

# Function to handle the key being picked up
func pickup_key():
	is_picked_up = true
	queue_free()  # This removes the key from the scene

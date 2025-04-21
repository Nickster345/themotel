extends Node3D

@export var key_name : String = "Key"  # You can change this to give the key a name if needed

# Function that gets called when the player interacts with the key
func on_interact():
	print("Picked up ", key_name)
	queue_free()  # Removes the key from the scene once it's picked up

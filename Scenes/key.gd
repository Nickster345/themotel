extends StaticBody3D

@export var key_name : String = "Key"
var is_picked_up = false

func _ready():
	add_to_group("interactable")

func on_interact():
	if !is_picked_up:
		var player = get_tree().get_first_node_in_group("player")
		if player:
			var character_body = player.get_node("Player")
			if character_body:
				if character_body.has_method("add_key"):
					character_body.add_key()
					is_picked_up = true
					remove_from_group("interactable")
					queue_free()
				else:
					print("Error: Player script is missing 'add_key' method!")
			else:
				print("Error: 'Player' node not found in player node!")
		else:
			print("Error: Player node not found!")
	else:
		print("Key already picked up!")

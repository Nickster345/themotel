extends Camera3D

@export var interaction_range : float = 5.0
var raycast : RayCast3D
var is_looking_at_interactable : bool = false
var current_interactable : Node3D = null

func _ready():
	raycast = $InteractionRay

func _process(delta):
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.is_in_group("interactable"):
			is_looking_at_interactable = true
			current_interactable = collider
		else:
			is_looking_at_interactable = false
			current_interactable = null
	else:
		is_looking_at_interactable = false
		current_interactable = null

	if is_looking_at_interactable and Input.is_action_just_pressed("ui_interact"):
		if current_interactable and is_instance_valid(current_interactable):
			current_interactable.on_interact()
			current_interactable = null

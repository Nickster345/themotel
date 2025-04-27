extends Control

@onready var inv: JournalInventory = preload("res://JournalInventory/journal_inventory.tres")
@onready var slots: Array = $GridContainer.get_children()

var is_open = false
var player: Node3D = null

func _ready():
	inv.update.connect(update_slots)
	update_slots()
	close()

func update_slots():
	for i in range(min(inv.slots.size(), slots.size())):
		slots[i].update(inv.slots[i])

func _process(delta):
	if Input.is_action_just_pressed("open_journal_inventory"):
		if is_open:
			close()
		else:
			open()

func open():
	player = get_player()
	if player:
		player.freeze_movement()
	visible = true
	is_open = true
	print("open called")

func close():
	player = get_player()
	if player:
		player.unfreeze_movement()
	visible = false
	is_open = false
	print("close called")


func get_player() -> CharacterBody3D:
	print("get_player called")
	var player_node = get_tree().current_scene.find_child("Player", true, false)
	if player_node:
		print("player_node found")
		var child_node:CharacterBody3D = player_node.find_child("Player", true, false) as CharacterBody3D
		if child_node:
			print("child_node found")
			return child_node
		else:
			print("child_node is null")
	else:
		print("player_node is null")
	return null

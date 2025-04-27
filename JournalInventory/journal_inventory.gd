extends Resource

class_name JournalInventory

signal update

@export var slots: Array[InvSlot]

func insert(item: JournalItem):
	var itemslots = slots.filter(func(slot): return slot.item == item)
	if itemslots.is_empty():
		var emptyslots = slots.filter(func(slot): return slot.item == null)
		if !emptyslots.is_empty():
			emptyslots[0].item = item
			
	update.emit()

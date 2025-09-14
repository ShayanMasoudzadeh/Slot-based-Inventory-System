extends PanelContainer

const Slot = preload("res://demo/Scenes/slot.tscn")

@onready var slot_grid: GridContainer = $MarginContainer/SlotGrid

func set_inventory_data(inventory_data: InventoryData) -> void:
	popoulate_slot_grid(inventory_data)

func popoulate_slot_grid(inventory_data : InventoryData) -> void:
	#clear children
	for child in slot_grid.get_children():
		child.queue_free()
	
	for slot_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		slot_grid.add_child(slot)
		
		if slot_data:
			slot.set_slot_data(slot_data)

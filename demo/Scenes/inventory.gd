extends PanelContainer

const Slot = preload("res://demo/Scenes/slot.tscn")

signal slot_interact(index: int, message: String)

@onready var slot_grid: GridContainer = $MarginContainer/SlotGrid

func set_inventory_data(inventory_data: InventoryData) -> void:
	slot_interact.connect(inventory_data._on_slot_interact)
	inventory_data.inventory_updated.connect(popoulate_slot_grid)
	popoulate_slot_grid(inventory_data)

func disconnect_signals(inventory_data: InventoryData) -> void:
	slot_interact.disconnect(inventory_data._on_slot_interact)
	inventory_data.inventory_updated.disconnect(popoulate_slot_grid)

func popoulate_slot_grid(inventory_data : InventoryData) -> void:
	#clear children
	for child in slot_grid.get_children():
		child.queue_free()
	
	for slot_data in inventory_data.slot_datas:
		var slot = Slot.instantiate()
		slot_grid.add_child(slot)
		
		slot.slot_clicked.connect(_on_slot_clicked)
		
		if slot_data:
			slot.set_slot_data(slot_data)

func _on_slot_clicked(index: int, button: int) -> void:
	var message: String
	if button == MOUSE_BUTTON_LEFT:
		message = "MOUSE_BUTTON_LEFT"
	elif button == MOUSE_BUTTON_RIGHT:
		message = "MOUSE_BUTTON_RIGHT"
	slot_interact.emit(index, message)

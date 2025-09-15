extends Control

var grabbed_slot_data: SlotData

@onready var player_inventory: PanelContainer = $PlayerInventory
@onready var grabbed_slot: PanelContainer = $GrabbedSlot

func _process(delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() - Vector2(32, 32)

func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(_on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)

func _on_inventory_interact(inventory_data: InventoryData, index: int, message: String) -> void:
	match [grabbed_slot_data, message]:
		[null, "MOUSE_BUTTON_LEFT"]:
			#grab item
			grabbed_slot_data = inventory_data.get_slot_data(index)
			inventory_data.clear_slot_data(index)
		[_, "MOUSE_BUTTON_LEFT"]:
			var clicked_slot = inventory_data.get_slot_data(index)
			if !clicked_slot:
				#put item
				inventory_data.set_slot_data(index, grabbed_slot_data)
				grabbed_slot_data = null
			else:
				if inventory_data.is_same_item(index, grabbed_slot_data) and !inventory_data.is_slot_full(index):
					#add item
					var leftover = inventory_data.add_to_slot_data(index, grabbed_slot_data.quantity)
					if leftover > 0:
						grabbed_slot_data.quantity = leftover
					else:
						grabbed_slot_data = null
				else:
					#swap item
					inventory_data.set_slot_data(index, grabbed_slot_data)
					grabbed_slot_data = clicked_slot
	
	update_grabbed_slot()

func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.set_slot_data(grabbed_slot_data)
		grabbed_slot.show()
	else:
		grabbed_slot.hide()

extends Control

var grabbed_slot_data: SlotData
var current_external_inventory_data: InventoryData 

@onready var player_inventory: PanelContainer = $PlayerInventory
@onready var external_inventory: PanelContainer = $ExternalInventory
@onready var grabbed_slot: PanelContainer = $GrabbedSlot

func _process(_delta: float) -> void:
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() - Vector2(32, 32)

func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(_on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)

func set_external_inventory(external_inventory_data: InventoryData) -> void:
	if current_external_inventory_data:
		clear_external_inventory()
	current_external_inventory_data = external_inventory_data
	external_inventory_data.inventory_interact.connect(_on_inventory_interact)
	external_inventory.set_inventory_data(external_inventory_data)

func toggle_external_inventory(external_inventory_data: InventoryData) -> void:
	if !current_external_inventory_data:
		set_external_inventory(external_inventory_data)
		external_inventory.show()
	elif current_external_inventory_data == external_inventory_data:
		clear_external_inventory()
		external_inventory.hide()
	else:
		clear_external_inventory()
		set_external_inventory(external_inventory_data)

func clear_external_inventory() -> void:
	current_external_inventory_data.inventory_interact.disconnect(_on_inventory_interact)
	external_inventory.disconnect_signals(current_external_inventory_data)
	current_external_inventory_data = null
	

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
				if inventory_data.set_slot_data(index, grabbed_slot_data) :
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
					if inventory_data.set_slot_data(index, grabbed_slot_data):
						grabbed_slot_data = clicked_slot
		[null, "MOUSE_BUTTON_RIGHT"]:
			#grab half items
			grabbed_slot_data = inventory_data.get_duplicate_slot_data(index)
			if grabbed_slot_data:
				if grabbed_slot_data.quantity > 1:
					var initial_quantity = grabbed_slot_data.quantity
					@warning_ignore("integer_division")
					grabbed_slot_data.quantity = grabbed_slot_data.quantity / 2
					inventory_data.set_slot_quantity(index, initial_quantity - grabbed_slot_data.quantity)
				else:
					grabbed_slot_data = null
		[_, "MOUSE_BUTTON_RIGHT"]:
			if inventory_data.is_slot_empty(index):
				var single_grabbed_slot_data = grabbed_slot_data.get_duplicate()
				single_grabbed_slot_data.quantity = 1
				if inventory_data.set_slot_data(index, single_grabbed_slot_data):
					grabbed_slot_data.quantity -= 1
				if grabbed_slot_data.quantity < 1:
					grabbed_slot_data = null
			elif inventory_data.is_same_item(index, grabbed_slot_data):
				var leftover = inventory_data.add_to_slot_data(index, 1)
				if leftover == 0:
					grabbed_slot_data.quantity -= 1
					if grabbed_slot_data.quantity < 1:
						grabbed_slot_data = null
	
	update_grabbed_slot()

func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.set_slot_data(grabbed_slot_data)
		grabbed_slot.show()
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	else:
		grabbed_slot.hide()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

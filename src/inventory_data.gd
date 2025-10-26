extends Resource
class_name InventoryData

# Signal emitted when the inventory contents change (e.g. item added, removed, or modified)
signal inventory_updated(inventory_data: InventoryData)
# Signal emitted when a slot interaction occurs (used by UI or input scripts)
signal inventory_interact(inventory_data: InventoryData, index: int, message: String)

# Array of SlotData objects representing each inventory slot
@export var slot_datas : Array[SlotData]
# Optional list of item tags this inventory accepts (for filtering containers, etc.)
@export var accepted_item_tags : Array[String]
# Icon used for empty slots (for UI representation)
@export var empty_slot_icon : AtlasTexture


# Returns the SlotData at the given index, or null if out of range
func get_slot_data(index: int) -> SlotData:
	if index < slot_datas.size():
		return slot_datas[index]
	else:
		push_error("index out of slot data array bound")
		return null


# Returns a duplicate (copy) of the SlotData at the given index, if it exists
func get_duplicate_slot_data(index: int) -> SlotData:
	if index < slot_datas.size():
		if slot_datas[index]:
			return slot_datas[index].get_duplicate()
		else:
			return null
	else:
		push_error("index out of slot data array bound")
		return null


# Sets a slot’s data if the item tag is accepted; returns true if successful
func set_slot_data(index: int, slot_data: SlotData) -> bool:
	if index < slot_datas.size():
		if has_accepted_tag(slot_data):
			slot_datas[index] = slot_data
			inventory_updated.emit(self)
			return true
		else: 
			return false
	else:
		push_error("index out of slot data array bound")
		return false


# Clears a slot (sets it to null) and emits an update signal
func clear_slot_data(index: int) -> void:
	if index < slot_datas.size():
		slot_datas[index] = null
		inventory_updated.emit(self)
	else:
		push_error("index out of slot data array bound")


# Adds a given quantity to the slot at index, respecting the max stack size
# Returns any leftover quantity that could not be added
func add_to_slot_data(index: int, quantity: int) -> int:
	var stack_size = slot_datas[index].get_item_stack_size()
	var current_quantity = slot_datas[index].quantity
	var leftover
	if current_quantity + quantity > stack_size:
		slot_datas[index].quantity = stack_size
		leftover = quantity - (stack_size - current_quantity)
	else:
		slot_datas[index].quantity = current_quantity + quantity
		leftover = 0
	inventory_updated.emit(self)
	return leftover


# Tries to add a SlotData item to the inventory
# Will merge with existing stacks if possible or place in an empty slot
# Returns true if the item was successfully added
func add_to_inventory(slot_data: SlotData) -> bool:
	if !has_accepted_tag(slot_data):
		return false
	var first_empty_slot_index : int = -1
	for index in slot_datas.size():
		# Record first empty slot if found
		if is_slot_empty(index) and first_empty_slot_index == -1:
			first_empty_slot_index = index
		# Try to merge item into existing stack if possible
		if can_fully_merge(index, slot_data):
			add_to_slot_data(index, slot_data.quantity)
			inventory_updated.emit(self)
			return true
	# If no merge possible, place in first empty slot
	if first_empty_slot_index != -1:
		slot_datas[first_empty_slot_index] = slot_data
		inventory_updated.emit(self)
		return true
	return false


# Sets the quantity of a slot directly
func set_slot_quantity(index: int, quantity: int) -> void:
	if index < slot_datas.size():
		slot_datas[index].quantity = quantity
		inventory_updated.emit(self)
	else:
		push_error("index out of slot data array bound")


# Checks if the inventory contains at least one instance of the given item ID
func inv_has_item(item_id : String) -> bool:
	for slot_data in slot_datas:
		if slot_data:
			if slot_data.get_item_id() == item_id:
				return true
	return false


# Returns the total quantity of an item across all slots in the inventory
func inv_item_total_quantity(item_id : String) -> int:
	var sum = 0
	for slot_data in slot_datas:
		if slot_data:
			if slot_data.get_item_id() == item_id:
				sum += slot_data.quantity
	return sum 


# Checks if the given SlotData’s tags are allowed by this inventory
# Returns true if there are no restrictions or if a matching tag is found
func has_accepted_tag(slot_data: SlotData) -> bool:
	if !accepted_item_tags.is_empty():
		for tag in slot_data.get_item_tags():
			for accepted_tag in accepted_item_tags:
				if tag == accepted_tag: return true
		return false
	return true


# Returns true if the given SlotData can fully merge into the slot at index
# (same item and enough stack space available)
func can_fully_merge(index: int, slot_data: SlotData) -> bool:
	if slot_datas[index] and slot_data:
		if is_same_item(index, slot_data) and \
				slot_data.quantity <= (slot_datas[index].get_item_stack_size() - slot_datas[index].quantity):
			return true
	return false


# Checks if a slot’s item is the same type as the given SlotData
func is_same_item(index: int, slot_data: SlotData) -> bool:
	if slot_datas[index] and slot_data:
		if slot_datas[index].get_item_id() == slot_data.get_item_id():
			return true
	return false


# Returns true if the slot at index has reached its maximum stack size
func is_slot_full(index) -> bool:
	if slot_datas[index].quantity == slot_datas[index].get_item_stack_size():
		return true
	else:
		return false


# Returns true if the slot is empty (contains no SlotData)
func is_slot_empty(index) -> bool:
	return !slot_datas[index]


# Prints the name and quantity of the slot at index for debugging
func print_slot (index: int) -> void:
	if slot_datas[index]:
		print("%s, %s" % [slot_datas[index].item_data.name, slot_datas[index].quantity])
	else:
		print("empty slot")


# Emits the inventory_interact signal when a slot interaction occurs
# Used by UI scripts to notify the inventory about player actions
func _on_slot_interact(index: int, message: String) -> void:
	inventory_interact.emit(self, index, message)

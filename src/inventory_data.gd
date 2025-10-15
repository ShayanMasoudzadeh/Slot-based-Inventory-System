extends Resource
class_name InventoryData

signal inventory_updated(inventory_data: InventoryData)
signal inventory_interact(inventory_data: InventoryData, index: int, message: String)

@export var slot_datas : Array[SlotData]
@export var accepted_item_tags : Array[String]


func get_slot_data(index: int) -> SlotData:
	if index < slot_datas.size():
		return slot_datas[index]
	else:
		push_error("index out of slot data array bound")
		return null

func get_duplicate_slot_data(index: int) -> SlotData:
	if index < slot_datas.size():
		if slot_datas[index]:
			return slot_datas[index].get_duplicate()
		else:
			return null
	else:
		push_error("index out of slot data array bound")
		return null

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

func clear_slot_data(index: int) -> void:
	if index < slot_datas.size():
		slot_datas[index] = null
		inventory_updated.emit(self)
	else:
		push_error("index out of slot data array bound")

func add_to_slot_data(index: int, quantity: int) -> int:
	var stack_size = slot_datas[index].get_item_stack_size()
	var current_quantity= slot_datas[index].quantity
	var leftover
	if current_quantity + quantity > stack_size:
		slot_datas[index].quantity = stack_size
		leftover = quantity - (stack_size - current_quantity)
	else:
		slot_datas[index].quantity = current_quantity + quantity
		leftover = 0
	inventory_updated.emit(self)
	return leftover

func add_to_inventory(slot_data: SlotData) -> bool:
	if !has_accepted_tag(slot_data):
		return false
	var first_empty_slot_index : int = -1
	for index in slot_datas.size():
		if is_slot_empty(index) and first_empty_slot_index == -1:
			first_empty_slot_index = index
		if can_fully_merge(index, slot_data):
			add_to_slot_data(index, slot_data.quantity)
			inventory_updated.emit(self)
			return true
	if first_empty_slot_index != -1:
		slot_datas[first_empty_slot_index] = slot_data
		inventory_updated.emit(self)
		return true
	return false

func set_slot_quantity(index: int, quantity: int) -> void:
	if index < slot_datas.size():
		slot_datas[index].quantity = quantity
		inventory_updated.emit(self)
	else:
		push_error("index out of slot data array bound")

func has_accepted_tag(slot_data: SlotData) -> bool:
	if !accepted_item_tags.is_empty():
		for tag in slot_data.get_item_tags():
			for accepted_tag in accepted_item_tags:
				if tag == accepted_tag: return true
		return false
	return true
func can_fully_merge(index: int, slot_data: SlotData) -> bool:
	if slot_datas[index] and slot_data:
		if is_same_item(index, slot_data) and \
				slot_data.quantity <= (slot_datas[index].get_item_stack_size() - slot_datas[index].quantity):
			return true
	return false
func is_same_item(index: int, slot_data: SlotData) -> bool:
	if slot_datas[index] and slot_data:
		if slot_datas[index].get_item_id() == slot_data.get_item_id():
			return true
	return false
func is_slot_full(index) -> bool:
	if slot_datas[index].quantity == slot_datas[index].get_item_stack_size():
		return true
	else:
		return false
func is_slot_empty(index) -> bool:
	return !slot_datas[index]

func print_slot (index: int) -> void:
	if slot_datas[index]:
		print("%s, %s" % [slot_datas[index].item_data.name, slot_datas[index].quantity])
	else:
		print("empty slot")

func _on_slot_interact(index: int, message: String) -> void:
	inventory_interact.emit(self, index, message)

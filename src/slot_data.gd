extends Resource
class_name SlotData

@export var item_data : ItemData
@export var quantity : int : set = set_quantity

func set_quantity(value: int) -> void:
	quantity = value
	if item_data:
		if quantity > item_data.stack_size:
			quantity = item_data.stack_size
			push_error("%s can't exceed max stack size, setting quantity to stack size" % item_data.id)

func get_item_id() -> String:
	if item_data:
		return item_data.id
	else:
		push_error("no item data to return ID")
		return ""

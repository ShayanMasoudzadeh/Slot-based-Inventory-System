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

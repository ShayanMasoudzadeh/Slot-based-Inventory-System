extends Resource
class_name SlotData

@export var item_data : ItemData
@export var quantity : int : set = set_quantity
@export var accepted_item_tags : Array[String]

func _init(_item_data: ItemData = null, _quantity: int = 0) -> void:
	item_data = _item_data
	quantity = _quantity

func set_quantity(value: int) -> void:
	quantity = value
	if item_data:
		if quantity > item_data.stack_size:
			quantity = item_data.stack_size
			push_error("%s can't exceed max stack size, setting quantity to stack size" % item_data.id)


func get_duplicate() -> SlotData:
	return SlotData.new(item_data, quantity)

func get_item_id() -> String:
	if item_data:
		return item_data.id
	else:
		push_error("no item data to return ID")
		return ""
func get_item_stack_size() -> int:
	if item_data:
		return item_data.stack_size
	else:
		push_error("no item data to return Stack Size")
		return 0
func get_item_meta_value(key: String) -> Variant:
	if item_data:
		if item_data.meta.has(key):
			return item_data.meta[key]
		else:
			push_error("Meta Key doesn't exist")
			return null
	else:
		push_error("no item data to return Meta")
		return null
func get_item_tags() -> Array[String]:
	if item_data:
		return item_data.tags
	else:
		push_error("no item data to return Tags")
		return []

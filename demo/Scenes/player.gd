extends Node

@export var inventory_data : InventoryData

func on_item_pickup(slot_data: SlotData) -> void:
	for i in range(slot_data.quantity):
		var single_item_slot = slot_data.get_duplicate()
		single_item_slot.set_quantity(1)
		var result : bool = inventory_data.add_to_inventory(single_item_slot)
		if result:
			slot_data.set_quantity(slot_data.quantity - 1)
		else:
			print("%s Item(s) can't be picked up." % slot_data.quantity)
			break
	#code for deleting the picked up item from world


func _on_pick_wood_button_pressed() -> void:
	on_item_pickup(SlotData.new(load("res://demo/items/wood.tres"), 1))

func _on_pick_stone_button_pressed() -> void:
	on_item_pickup(SlotData.new(load("res://demo/items/stone.tres"), 1))

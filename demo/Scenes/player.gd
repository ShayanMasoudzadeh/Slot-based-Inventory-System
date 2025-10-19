extends Node

@export var inventory_data : InventoryData
@export var chestgear_inventory_data : InventoryData
@export var headgear_inventory_data : InventoryData
@export var footgear_inventory_data : InventoryData

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

func calculate_total_defence() -> float:
	var armour_datas : Array[InventoryData] = [chestgear_inventory_data, headgear_inventory_data, footgear_inventory_data]
	var total_defence := 0.0
	for armour_data in armour_datas:
		if !armour_data.is_slot_empty(0):
			var defence_value = armour_data.get_slot_data(0).get_item_meta_value("defence")
			if defence_value:
				total_defence += defence_value
	return total_defence

func _on_pick_wood_button_pressed() -> void:
	on_item_pickup(SlotData.new(load("res://demo/items/wood.tres"), 1))

func _on_pick_stone_button_pressed() -> void:
	on_item_pickup(SlotData.new(load("res://demo/items/stone.tres"), 1))

func _on_pick_armour_button_pressed() -> void:
	on_item_pickup(SlotData.new(load("res://demo/items/armour.tres"), 1))


func _on_print_defence_button_pressed() -> void:
	print(calculate_total_defence())

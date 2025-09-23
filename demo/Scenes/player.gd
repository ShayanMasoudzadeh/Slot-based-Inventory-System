extends Node

@export var inventory_data : InventoryData

func on_item_pickup(slot_data: SlotData) -> void:
	var result : bool = inventory_data.add_to_inventory(slot_data)
	if !result:
		print("Item can't be picked up.")
	#code for deleting the picked up item from world


func _on_pick_wood_button_pressed() -> void:
	on_item_pickup(SlotData.new(load("res://demo/items/wood.tres"), 1))

func _on_pick_stone_button_pressed() -> void:
	on_item_pickup(SlotData.new(load("res://demo/items/stone.tres"), 1))

extends Node

signal total_defense_updated(total_defense: float)
signal message(message: String)

@export var inventory_data : InventoryData
@export var chestgear_inventory_data : InventoryData
@export var headgear_inventory_data : InventoryData
@export var footgear_inventory_data : InventoryData

func _ready() -> void:
	headgear_inventory_data.inventory_updated.connect(update_total_defense)
	chestgear_inventory_data.inventory_updated.connect(update_total_defense)
	footgear_inventory_data.inventory_updated.connect(update_total_defense)

func on_item_pickup(slot_data: SlotData) -> void:
	for i in range(slot_data.quantity):
		var single_item_slot = slot_data.get_duplicate()
		single_item_slot.set_quantity(1)
		var result : bool = inventory_data.add_to_inventory(single_item_slot)
		if result:
			slot_data.set_quantity(slot_data.quantity - 1)
		else:
			message.emit("%s Item(s) can't be picked up." % slot_data.quantity)
			#print("%s Item(s) can't be picked up." % slot_data.quantity)
			break
	#code for deleting the picked up item from world

func update_total_defense(_inventory_data: InventoryData) -> void:
	var armour_datas : Array[InventoryData] = [chestgear_inventory_data, headgear_inventory_data, footgear_inventory_data]
	var total_defense := 0.0
	for armour_data in armour_datas:
		if !armour_data.is_slot_empty(0):
			var defense_value = armour_data.get_slot_data(0).get_item_meta_value("defense")
			if defense_value:
				total_defense += defense_value
	total_defense_updated.emit(total_defense)


func _on_pick_1_wood_button_pressed() -> void:
	on_item_pickup(SlotData.new(load("res://demo/items/wood.tres"), 1))

func _on_pick_5_wood_button_pressed() -> void:
	on_item_pickup(SlotData.new(load("res://demo/items/wood.tres"), 5))

func _on_pick_1_stone_button_pressed() -> void:
	on_item_pickup(SlotData.new(load("res://demo/items/stone.tres"), 1))

func _on_pick_5_stone_button_pressed() -> void:
	on_item_pickup(SlotData.new(load("res://demo/items/stone.tres"), 5))

func _on_pick_1_armour_button_pressed() -> void:
	on_item_pickup(SlotData.new(load("res://demo/items/armour.tres"), 1))

func _on_pick_1_boots_button_pressed() -> void:
	on_item_pickup(SlotData.new(load("res://demo/items/boots.tres"), 1))

func _on_pick_1_helmet_button_pressed() -> void:
	on_item_pickup(SlotData.new(load("res://demo/items/helmet.tres"), 1))

func _on_pick_1_apple_button_pressed() -> void:
	on_item_pickup(SlotData.new(load("res://demo/items/apple.tres"), 1))

func _on_pick_5_apple_button_pressed() -> void:
	on_item_pickup(SlotData.new(load("res://demo/items/apple.tres"), 5))

func _on_pick_1h_potion_button_pressed() -> void:
	on_item_pickup(SlotData.new(load("res://demo/items/health_potion.tres"), 1))

func _on_pick_5h_potion_button_pressed() -> void:
	on_item_pickup(SlotData.new(load("res://demo/items/health_potion.tres"), 5))

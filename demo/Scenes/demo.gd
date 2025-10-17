extends Node

@onready var player: Node = $Player
@onready var inventory_interface: Control = $CanvasLayer/InventoryInterface

func _ready() -> void:
	inventory_interface.set_player_inventory_data(player.inventory_data, player.headgear_inventory_data, player.chestgear_inventory_data, player.footgear_inventory_data)

func toggle_external_inventory(inventory_data: InventoryData) -> void:
	inventory_interface.toggle_external_inventory(inventory_data)


func _on_container1_button_pressed() -> void:
	toggle_external_inventory($Container1.inventory_data)

func _on_container_2_button_pressed() -> void:
	toggle_external_inventory($Container2.inventory_data)


func _on_inventory_interface_drop_slot_data(slot_data: SlotData) -> void:
	print("%s %s(s) dropped." % [slot_data.quantity, slot_data.item_data.name])

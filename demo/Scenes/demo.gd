extends Node

@onready var player: Node = $Player
@onready var inventory_interface: Control = $CanvasLayer/InventoryInterface

func _ready() -> void:
	inventory_interface.set_player_inventory_data(player.inventory_data)

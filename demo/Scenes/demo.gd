extends Node

@onready var player: Node = $Player
@onready var inventory_interface: Control = $CanvasLayer/InventoryInterface

@onready var messages_text_label: RichTextLabel = $CanvasLayer/UI/PanelContainer/HBoxContainer/VBoxContainer3/PanelContainer/MessagesTextLabel

func _ready() -> void:
	inventory_interface.set_player_inventory_data(player.inventory_data, player.headgear_inventory_data, player.chestgear_inventory_data, player.footgear_inventory_data)
	inventory_interface.interface_sound.connect($UIAudio.play_inventory_interface_sound)
	
	player.total_defense_updated.connect(inventory_interface._update_total_defense)
	player.message.connect(print_message)

func toggle_external_inventory(inventory_data: InventoryData) -> void:
	inventory_interface.toggle_external_inventory(inventory_data)

func print_message(message: String) -> void:
	messages_text_label.text += "\n-" + message

func _on_material_container_button_pressed() -> void:
	toggle_external_inventory($MaterialContainer.inventory_data)
func _on_consumable_container_button_pressed() -> void:
	toggle_external_inventory($ConsumableContainer.inventory_data)
func _on_small_container_button_pressed() -> void:
	toggle_external_inventory($SmallContainer.inventory_data)

func _on_inventory_interface_drop_slot_data(slot_data: SlotData) -> void:
	print_message("%s %s(s) dropped." % [slot_data.quantity, slot_data.item_data.name])

extends PanelContainer

@onready var icon_texture: TextureRect = $MarginContainer/IconTexture
@onready var quantity_label: Label = $MarginContainer/QuantityLabel

func set_slot_data(slot_data : SlotData) -> void:
	if slot_data.item_data:
		var item_data = slot_data.item_data
		icon_texture.texture = item_data.icon
		tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
		
		if slot_data.quantity > 1:
			quantity_label.text = "%s" % slot_data.quantity
			quantity_label.show()

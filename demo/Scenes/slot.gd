extends PanelContainer

@onready var icon_texture: TextureRect = $MarginContainer/IconTexture
@onready var quantity_label: Label = $MarginContainer/QuantityLabel

signal slot_clicked(index: int, button: int)

func set_slot_data(slot_data : SlotData) -> void:
	quantity_label.hide()
	if slot_data.item_data:
		var item_data = slot_data.item_data
		icon_texture.texture = item_data.icon
		tooltip_text = "%s\n%s" % [item_data.name, item_data.description]
		
		if slot_data.quantity > 1:
			quantity_label.text = "%s" % slot_data.quantity
			quantity_label.show()

func set_slot_icon(icon: Texture2D) -> void:
	icon_texture.texture = icon
	icon_texture.modulate.a = 0.3

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton \
			and (event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT) \
			and event.is_pressed():
		slot_clicked.emit(get_index(), event.button_index)

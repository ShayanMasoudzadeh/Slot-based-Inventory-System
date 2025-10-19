extends Node

func _ready() -> void:
	for button in get_tree().get_nodes_in_group("ui_button"):
		button.pressed.connect(self.play_click)

func play_click() -> void:
	$UIClick.play()
func play_inventory_interface_sound(stream: String) -> void:
	match stream:
		"put":
			$UIPut.pitch_scale = randf_range(0.8, 0.89)
			$UIPut.play()
		"grab":
			$UIGrab.pitch_scale = randf_range(1.25, 1.35)
			$UIGrab.play()

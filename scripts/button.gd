extends StaticBody3D

@onready var actual_button = $ActualButton
@onready var label = $Label3D

var pressed_times = 3

func _on_area_3d_body_entered(body):
	if body == actual_button:
		if pressed_times > 0:
			pressed_times -= 1
			label.text = str(pressed_times)
			if pressed_times == 0:
				label.modulate = Color("00e888")

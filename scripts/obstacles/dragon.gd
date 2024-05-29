extends StaticBody3D

@onready var button = $Button
@onready var indic = $Sprite3D

func _on_area_3d_body_entered(body):
	if body == button:
		indic.transparency = 0

func _ready():
	indic.transparency = 100
	

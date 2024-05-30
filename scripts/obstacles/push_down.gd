extends StaticBody3D

@onready var button = $Button
@onready var indic = $Label3D
@onready var joint = $JoltGeneric6DOFJoint3D

func _on_area_3d_body_entered(body):
	if body == button:
		indic.transparency = 0
		joint.set_flag_y(JoltGeneric6DOFJoint3D.FLAG_ENABLE_LINEAR_MOTOR, false)

func _ready():
	indic.transparency = 100
	

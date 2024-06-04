extends StaticBody3D

@onready var rigid_body_3d = %RigidBody3D
@onready var label = $Label3D

# Called when the node enters the scene tree for the first time.
func _ready():
	label.transparency = 100

func _on_area_3d_body_entered(body):
	if body == rigid_body_3d:
		rigid_body_3d.freeze = true
		label.transparency = 0

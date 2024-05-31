class_name Motor
extends JoltGeneric6DOFJoint3D

#@onready var motor = $Motor
@export var arm : RigidBody3D

func run(speed: float):
	set_param_x(JoltGeneric6DOFJoint3D.PARAM_ANGULAR_MOTOR_TARGET_VELOCITY, speed / 30)
	fix_arm()
	
func fix_arm():
	arm.position = Vector3.ZERO

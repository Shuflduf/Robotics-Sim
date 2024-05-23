class_name Motor
extends JoltGeneric6DOFJoint3D

#@onready var motor = $Motor
@export var arm : RigidBody3D

func run(speed: float):
	#if speed == 0:
		#arm.freeze = true
		#return
	#else:
		#arm.freeze = false
	set_param_x(JoltGeneric6DOFJoint3D.PARAM_ANGULAR_MOTOR_TARGET_VELOCITY, speed / 30)
	

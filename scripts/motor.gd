class_name Motor
extends RigidBody3D

func run(_speed: float):
	return
	#if speed == 0:
		#rigid_body.freeze = true
		#return
	#else:
		#rigid_body.freeze = false
	#joint.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, deg_to_rad(speed))
	

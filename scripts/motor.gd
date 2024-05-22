class_name Motor
extends StaticBody3D

@onready var joint: HingeJoint3D = %HingeJoint3D
@onready var rigid_body = $RigidBody3D

func run(speed):
	if speed == 0:
		rigid_body.freeze = true
		return
	else:
		rigid_body.freeze = false
	joint.set_param(HingeJoint3D.PARAM_MOTOR_TARGET_VELOCITY, deg_to_rad(speed))
	

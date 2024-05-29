class_name Airplane
extends Vehicle

func _ready():
	await move(2000, 10)
	
func _physics_process(delta):
	#var boost_dir: Vector3 = linear_velocity
	#boost_dir = boost_dir.rotated(Vector3.UP, global_rotation.y)
	#var force = Vector3(0, boost_dir.z, 0)
	#print(force)
	#apply_central_force(Vector3.FORWARD)
	position.z += 10 * delta

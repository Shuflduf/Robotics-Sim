class_name Vehicle
extends VehicleBody3D

@export var wheels: Array[VehicleWheel3D]
@export var enabled := true

enum DIRECTION {
	Left,
	Right,
	None,
}

func timer(time):
	await get_tree().create_timer(time).timeout
	return

func turn(dir: DIRECTION, strength: int, time: float):
	for wheel in wheels:
		match wheel.desired_direction:
			DIRECTION.None:
				pass
			dir:
				wheel.engine_force = -strength * 50
			_:
				wheel.engine_force = strength * 50
	await timer(time)
	
	for wheel in wheels:
		wheel.engine_force = 0
	
	await timer(0.5)
	return

func move(power: int, time: float):
	engine_force = power
	await timer(time)
	engine_force = 0
	return
	
func stop(power: int):
	brake = power
	await timer(0.5)
	brake = 0
	return

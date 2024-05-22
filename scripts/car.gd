extends VehicleBody3D

@onready var pickup_detect = %PickupDetect
@onready var pickup_pos = %PickupPos
@onready var motor: Motor = $Motor

@onready var wheels = [%VehicleWheel3D1, %VehicleWheel3D2, %VehicleWheel3D3, %VehicleWheel3D4]

var held_item: RigidBody3D

const FAR_PICKUP_POS = Vector3(0, -0.7, 1.7)
const NORMAL_PICKUP_POS = Vector3(0, -0.4, 0.8)

@export var normal_pickup: bool = true

enum DIRECTION {
	Left,
	Right,
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pickup_pos.position = NORMAL_PICKUP_POS if normal_pickup else FAR_PICKUP_POS
	
	await timer(1)
	await move(20, 2)
	await grab()
	await move(-20, 2)
	await stop(100)
	await turn(DIRECTION.Right, 5, 1)
	await let_go(30)
	await move(15, 3)
	await stop(50)
	await grab()
	await turn(DIRECTION.Left, 50, 2.2)
	await move(-20, 2.5)
	await stop(20)
	await turn(DIRECTION.Right, 5, 2.2)
	await move(-10, 0.5)
	await stop(20)
	#for i in 3:	
		#brake = 100
		#await push_down()
	brake = 0
	await move(300, 10)
		
func grab():
	print(pickup_detect.get_overlapping_bodies())
	if not pickup_detect.get_overlapping_bodies().is_empty():
		held_item = pickup_detect.get_overlapping_bodies()[0]
		held_item.freeze = true
		var temp_pos = held_item.global_transform
		held_item.get_parent().remove_child(held_item)
		add_child(held_item)
		held_item.global_transform = temp_pos
		
		var pos_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
		pos_tween.tween_property(held_item, "global_transform", pickup_pos.global_transform, 0.5)
		
		#held_item.rotation = Vector3.ZERO
		await pos_tween.finished
		held_item.global_transform = pickup_pos.global_transform
		await timer(0.5)
		return
		
func let_go(force: int = 0):
	if held_item != null:
		held_item.freeze = false
		var temp_pos = held_item.global_transform
		#held_item.position = held_item.global_position
		remove_child(held_item)
		get_tree().root.get_child(0).add_child(held_item)	
		held_item.global_transform = temp_pos
		held_item.apply_impulse((Vector3.FORWARD.rotated(\
			Vector3.UP, deg_to_rad(global_rotation_degrees.y + 180)) * force) + Vector3.UP * force / 10)
		
		held_item = null
	await timer(0.5)
	return
		
func push_down():
	motor.run(60)
	await get_tree().create_timer(1.5).timeout
	motor.run(-60)
	await get_tree().create_timer(0.8).timeout
	motor.run(0)
	await timer(0.5)
	return

func timer(time):
	await get_tree().create_timer(time).timeout
	return

func throw(force: int):
	if held_item != null:
		held_item.freeze = false
		held_item.position = held_item.global_position
		held_item.apply_impulse((Vector3.FORWARD.rotated(\
			Vector3.UP, deg_to_rad(global_rotation_degrees.y + 180)) * force) + Vector3.UP * force / 10)
		remove_child(held_item)
		get_tree().root.get_child(0).add_child(held_item)	
		held_item = null
	await timer(0.5)
	return

func turn(dir: DIRECTION, strength: int, time: float):
	for wheel in wheels:
		if wheel.desired_direction == dir:
			wheel.engine_force = -strength * 50
			print("AJKGFHD")
		else:
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

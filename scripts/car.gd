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
	engine_force = 20
	await timer(2)
	engine_force = 0
	brake = 40
	await grab()
	await timer(0.5)
	#steering = deg_to_rad(179)
	brake = 0
	engine_force = -20
	await timer(1)
	turn(DIRECTION.Right, 10, 2)
	#engine_force = 30
	await timer(1)
	throw(60)
	
	#for i in 3:
		#await pickup_and_drop()
	#
	#await grab()
	#engine_force = -20

func grab():
	print(pickup_detect.get_overlapping_bodies())
	if not pickup_detect.get_overlapping_bodies().is_empty():
		held_item = pickup_detect.get_overlapping_bodies()[0]
		held_item.freeze = true
		var temp_pos = held_item.global_position
		var temp_rot = held_item.global_rotation
		held_item.get_parent().remove_child(held_item)
		add_child(held_item)
		held_item.global_position = temp_pos
		held_item.global_rotation = temp_rot
		var pos_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CIRC)
		pos_tween.tween_property(held_item, "global_position", pickup_pos.global_position, 0.5)
		held_item.rotation = Vector3.ZERO
		await pos_tween.finished
		held_item.global_position = pickup_pos.global_position
		return
		
func let_go():
	if held_item != null:
		held_item.freeze = false
		held_item.position = held_item.global_position
		remove_child(held_item)
		get_tree().root.get_child(0).add_child(held_item)	
		held_item = null
		
func push_down():
	motor.run(60)
	await get_tree().create_timer(1).timeout
	motor.run(-60)
	await get_tree().create_timer(0.5).timeout
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

func turn(dir: DIRECTION, strength: int, time: int):
	for wheel in wheels:
		if wheel.desired_direction == dir:
			wheel.engine_force = -strength * 50
			print("AJKGFHD")
		else:
			wheel.engine_force = strength * 50
	await timer(time)
	for wheel in wheels:

		wheel.engine_force = 0

		

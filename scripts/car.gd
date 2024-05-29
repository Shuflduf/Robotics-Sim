class_name Car
extends Vehicle

@onready var pickup_detect = %PickupDetect
@onready var pickup_pos = %PickupPos
@onready var motor: Motor = $Motor

var held_item: RigidBody3D

const FAR_PICKUP_POS = Vector3(0, -0.7, 1.7)
const NORMAL_PICKUP_POS = Vector3(0, -0.4, 0.8)

@export var normal_pickup: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if !enabled:
		queue_free()
		
	pickup_pos.position = NORMAL_PICKUP_POS if normal_pickup else FAR_PICKUP_POS
	
	await timer(1)
	await turn(DIRECTION.Left, 5, 0.3)
	await move(30, 3)
	await move(150, 2.3)
	#await timer(0.5)
	await stop(5)
	await turn(DIRECTION.Right, 40, 0.4)
	await move(-40, 1.8)
	await stop(10)
	for i in 3:
		await push_down()
	#await motor.run(-200)
	
#region two
	#await timer(1)
	#await turn(DIRECTION.Right, 5, 1)
	#await move(20, 2)
	#await stop(5)
	#await turn(DIRECTION.Left, 3, 0.6)
	#await move(20, 2)
#endregion
	
#region one
	#await timer(1)
	#await move(20, 2)
	#await grab()
	#await move(-20, 2)
	#await stop(100)
	#await turn(DIRECTION.Right, 5, 1)
	#await let_go(30)
	#await move(15, 3.5)
	#await stop(20)
	#await grab()
	#await turn(DIRECTION.Left, 50, 2.2)
	#await move(-20, 2.5)
	#await stop(20)
	#await turn(DIRECTION.Right, 5, 2.3)
	#await move(-10, 1)
	#await stop(20)
	#for i in 3:	
		#brake = 100
		#await push_down()
	#brake = 0
	#await let_go(100)
	#await move(300, 10)
#endregion
		
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
		var impulse = func(object : RigidBody3D, forward := true):
			var dir = 180 if forward else 0
			object.apply_impulse((Vector3.FORWARD.rotated(\
			Vector3.UP, deg_to_rad(global_rotation_degrees.y + dir)) * force)\
			+ Vector3.UP * force / 10)
			
		impulse.call(held_item)
		impulse.call(self, false)
		
		held_item = null
	await timer(0.5)
	return
		
func push_down():
	motor.run(60)
	await timer(1.5)
	motor.run(-60)
	await timer(0.8)
	motor.run(0)
	await timer(0.5)
	return



func throw(force: int):
	if held_item != null:
		held_item.freeze = false
		held_item.position = held_item.global_position
		var impulse = func(forward := true):
				apply_impulse((Vector3.FORWARD.rotated(Vector3.UP, \
				deg_to_rad(global_rotation_degrees.y + (180 if forward else -180))) * force)\
				+ Vector3.UP * force / 10)
		held_item.impulse.call()
		self.impulse.call()
		remove_child(held_item)
		get_tree().root.get_child(0).add_child(held_item)	
		held_item = null
	await timer(0.5)
	return





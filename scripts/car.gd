extends VehicleBody3D

@onready var animation_player = $AnimationPlayer
@onready var right_hand = $RightHand
@onready var left_hand = $LeftHand


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(1).timeout
	#engine_force = 200
	#await get_tree().create_timer(1.5).timeout
	#engine_force = 0
	#brake = 200
	#await get_tree().create_timer(1).timeout
	#brake = 0
	grab()
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func grab():
	animation_player.play("Grab")

	

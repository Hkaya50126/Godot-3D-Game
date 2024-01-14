extends CharacterBody3D

var turn_speed=45
var speed=20

var turn_right=false
var turn_left=false
var is_deleted=false
var is_fired=false

@onready var firstPersonCamera=$Head/Camera3D
@onready var thirdPersonCamera=$CameraThirtPerson
var isFirstPerson : bool = true

var rot_x=0.0
var rot_y=0.0
var rot_z=0.0

@onready var movement_guide=$MovementGuide
@onready var collision_shape=$CollisionShape3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	if is_deleted==true && is_fired==false:
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			is_fired=true
			
			speed=15
			throw_grenade()
			
			$LeftHandBall2.visible = not $LeftHandBall2.visible
				
			$"../Ball".visible = not $"../Ball".visible
			$Head/Crosshair.visible = not $Head/Crosshair.visible
			$Mage/Rig/Skeleton3D/Spellbook.visible = not $Mage/Rig/Skeleton3D/Spellbook.visible
			$Mage/Rig/Skeleton3D/Spellbook_open.visible = not $Mage/Rig/Skeleton3D/Spellbook_open.visible
				
	else:
		is_deleted=false
		is_fired=false	
	#firstPersonCamera.rotation.x=clamp(firstPersonCamera.rotation.x,-0.5,0.5)
	#firstPersonCamera.rotation.y=clamp(firstPersonCamera.rotation.y,-180,-140)

	

func _physics_process(delta):
	get_input(delta)
	
	if turn_right:
		rot_z -= 0.5
	elif  rot_z < 0:
		rot_z += 0.5
	if turn_left:
		rot_z += 0.5
	elif  rot_z > 0:
		rot_z -= 0.5
	
	rot_z=clamp(rot_z,-30.0,30)
	rotation_degrees.x=rot_x
	rotation_degrees.y=rot_y
	rotation_degrees.z=rot_z
	translate(-movement_guide.transform.basis.z*speed*delta)
	

func _input(event):
	if event is InputEventMouseMotion and firstPersonCamera.current==true:
		firstPersonCamera.rotate(Vector3.UP,-event.relative.x*0.003)
		firstPersonCamera.rotate_object_local(Vector3.RIGHT,-event.relative.y*0.003)
		firstPersonCamera.rotation.x=clamp(firstPersonCamera.rotation.x,-0.5,0.5)
		var current_rotation_y = firstPersonCamera.rotation_degrees.y
		current_rotation_y = clamp(current_rotation_y + event.relative.y * -0.003, -75.0, 75.0)
		firstPersonCamera.rotation_degrees.y=current_rotation_y		

	if event is InputEventMouseMotion and thirdPersonCamera.current==true:
		thirdPersonCamera.rotate(Vector3.UP,-event.relative.x*0.003)
		thirdPersonCamera.rotate_object_local(Vector3.RIGHT,-event.relative.y*0.003)
		var current_rotation_y = thirdPersonCamera.rotation_degrees.y
		current_rotation_y = clamp(current_rotation_y + event.relative.y * -0.003, -75.0, 75.0)
		thirdPersonCamera.rotation_degrees.y=current_rotation_y	
		
func get_input(delta):
	if Input.is_action_pressed("up_key"):
		rot_x+=turn_speed*delta
	if Input.is_action_pressed("switch_camera"):
		$"Mage/Rig/Skeleton3D/2H_Staff".visible = not $"Mage/Rig/Skeleton3D/2H_Staff".visible
		switch_camera()
	if Input.is_action_pressed("down_key"):
		rot_x+=-turn_speed*delta
	if Input.is_action_pressed("stop_key") and is_deleted==false and is_fired==false:
		speed=0		
		print(is_deleted)
		print(is_fired)
	if Input.is_action_pressed("stop_key")==false and is_deleted==false and is_fired==false:
		speed=15	
	if Input.is_action_pressed("right_key"):
		rot_y+=-turn_speed*delta
		turn_right=true
		
	elif rot_z < 0.0:
		turn_right=false
		
	if Input.is_action_pressed("left_key"):
		rot_y+=turn_speed*delta
		turn_left=true
		
	elif rot_z > 0.0:
		turn_left=false

func switch_camera():
	isFirstPerson = not isFirstPerson
	firstPersonCamera.current = isFirstPerson
	thirdPersonCamera.current = not isFirstPerson
	$Head/staff.visible = not $Head/staff.visible
	

func _on_area_3d_body_entered(body):
	if body.is_in_group("ballgroup") and is_deleted==false:
		
		speed=15
		$LeftHandBall2.visible = not $LeftHandBall2.visible
		$"../Ball".visible = not $"../Ball".visible
		$Head/Crosshair.visible = not $Head/Crosshair.visible
		$Mage/Rig/Skeleton3D/Spellbook.visible = not $Mage/Rig/Skeleton3D/Spellbook.visible
		$Mage/Rig/Skeleton3D/Spellbook_open.visible = not $Mage/Rig/Skeleton3D/Spellbook_open.visible
		
		is_deleted=true
		is_fired=false
	elif body.is_in_group("ghostgroup") and is_fired==false:
		get_tree().change_scene_to_file("res://Scenes/finish_scene.tscn")
	
	
		
		
func _on_area_3d_body_exited(body):
	if is_deleted==false:
		speed=15
	


func _on_player_node_body_entered(body):
	pass # Replace with function body.

const GrenadeScene = preload("res://Map/ball_rigidbody.tscn")

# Call this when the player presses the button to throw a grenade
func throw_grenade():
	# Get camera position and direction
	var camera := get_viewport().get_camera_3d()
	var camera_transform := camera.global_transform
	var forward := -camera_transform.basis.z
	
	# Spawn grenade sligtly in front of the camera,
	# with some added velocity so it moves forward.
	# The offset is also to make sure it doesn't collide with the player throwing it.
	var grenade : RigidBody3D = GrenadeScene.instantiate()
	grenade.position = camera_transform.origin + forward * 7
	grenade.linear_velocity = forward * 40.0
	var level := get_parent()
	level.add_child(grenade)

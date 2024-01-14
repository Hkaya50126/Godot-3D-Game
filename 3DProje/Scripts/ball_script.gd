extends CharacterBody3D


var speeds: int=10
var vel:Vector3


func _ready():
	randomize()
	
func _physics_process(delta):
	var target=$NavigationAgent3D.get_next_path_position()
	var pos=get_global_transform().origin
	
	var n=$RayCast3D.get_collision_normal()
	if n.length_squared()<0.001:
		n=Vector3(0,1,0)
	
	vel=(target-pos).slide(n).normalized()*speeds
	$ball.rotation.y=lerp_angle($ball.rotation.y,atan2(vel.x,vel.z),delta*10)
	
	$NavigationAgent3D.set_velocity(vel)
	move_and_slide()

func move_to(target_pos):
	var closest_pos=NavigationServer3D.map_get_closest_point(get_world_3d().get_navigation_map(),target_pos)
	$NavigationAgent3D.set_target_position(closest_pos)


func get_random_pos_in_sphere(radius: float) -> Vector3:
	var x1 = randf_range(-1, 1)
	var x2 = randf_range(-1, 1)

	while x1 * x1 + x2 * x2 >= 1:
		x1 = randf_range(-1, 1)
		x2 = randf_range(-1, 1)

	var random_pos_on_unit_sphere = Vector3(
		1 - 2 * (x1 * x1 + x2 * x2),
		0,
		1 - 2 * (x1 * x1 + x2 * x2)
	)

	random_pos_on_unit_sphere.x *= randi_range(-radius,radius)
	random_pos_on_unit_sphere.z *= randi_range(-radius,radius)

	return random_pos_on_unit_sphere

func _on_timer_timeout():
	var sphere_point=get_random_pos_in_sphere(200)
	move_to(sphere_point)

func _on_navigation_agent_3d_velocity_computed(safe_velocity):

	set_velocity(safe_velocity)


func _on_navigation_agent_3d_navigation_finished():
	pass # Replace with function body.
	$Timer.start()

func _on_area_3d_body_entered(body):
	pass

func _on_area_3d_body_exited(body):
	pass

extends Node3D

@onready var pausemenu=$PauseMenu
var paused=false

func _process(delta):
	if Input.is_action_pressed("pause_menu"):
		pauseMenu()
		
func pauseMenu():
	if paused:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		pausemenu.hide()
		Engine.time_scale=1
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
		pausemenu.show()
		Engine.time_scale=0
		
	paused=!paused

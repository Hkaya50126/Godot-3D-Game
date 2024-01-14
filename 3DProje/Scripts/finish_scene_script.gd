extends Control

@onready var sound=$FailSound
# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureRect/Point.text=str(GlobalPointScripts.point)
	sound.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_quit_pressed():
	get_tree().quit()


func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

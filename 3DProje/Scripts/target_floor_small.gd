extends Area3D

@onready var point_val=$"../../../../PointControl/PointPanel/PointLabel"
@onready var sound=$"../../../../fanfareSound"
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group("ballRigidbodyGroup"):
		GlobalPointScripts.point+=100
		point_val.text=str(GlobalPointScripts.point)
		sound.play()


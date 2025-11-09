extends Node2D

@export var weapon_name := "BaseWeapon"
@export var damage := 10.0
@export var jab_speed := 10   
var jabbing


func _physics_process(delta):
	if Input.is_action_just_pressed("attack")and not jabbing:
		attack()
		
func attack():
	print(weapon_name, "swung! Dealing", damage, "damage.")
	jabbing = true
	swing_arc()

func swing_arc():
	print("no")
	var t=0

	var start_pos = Vector2.ZERO
	var end_pos = Vector2(-30, 0).rotated(rotation)
	
	while t < 1.0:
		t += get_process_delta_time() * jab_speed
		position = start_pos.lerp(end_pos, t)
		await get_tree().process_frame
		
	t = 0.0
	while t < 1.0:
		t += get_process_delta_time() * jab_speed
		position = end_pos.lerp(start_pos, t)
		await get_tree().process_frame

	position = start_pos
	jabbing = false
	

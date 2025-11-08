extends CharacterBody2D

@export var speed := 400.0        
@export var acceleration := 4000.0
@export var friction := 3000.0         
@export var dash_speed := 1000.0       
@export var dash_duration := 0.3       
@export var dash_cooldown := 0.3       

var dash_timer := 0.0
var dash_cooldown_timer := 0.0
var is_dashing := false

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if dash_timer > 0:
		dash_timer -= delta
	elif is_dashing:
		is_dashing = false
		dash_cooldown_timer = dash_cooldown
	
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	if Input.is_action_just_pressed("dash") and not is_dashing and dash_cooldown_timer <= 0:
		is_dashing = true
		dash_timer = dash_duration
	

	if input_vector != Vector2.ZERO:
		var target_speed = speed
		if is_dashing:
			target_speed = dash_speed
		velocity = velocity.move_toward(input_vector * target_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()

func player_damage(damage: float) -> void:
	var Player_Health =  get_meta("Player_Health")
	print("Player took damage", Player_Health)
	Player_Health -= damage
	if Player_Health <= 0:
		Player_Health = 0
		die()
	set_meta("Player_Health",Player_Health)
func die() -> void:
	print("Player has died!")

extends CharacterBody2D

@onready var anim_sprite := $body
@onready var anim_sprite2 := $body/arm
@onready var anim_attack := $WeaponSlot/attack
@onready var weapon :=$WeaponSlot/weapon
var input_vector := Vector2.ZERO

@export var projectile_node : PackedScene

@export var speed := 400.0        
@export var acceleration := 4000.0
@export var friction := 3000.0         
@export var dash_speed := 1000.0       
@export var dash_duration := 0.3       
@export var dash_cooldown := 0.3   
@onready var weapon_slot = $WeaponSlot   



var attacking := false
var can_attack := true
@export var attack_cooldown := 1.0  # seconds 

var dash_timer := 0.0
var dash_cooldown_timer := 0.0
var is_dashing := false

func _input(event):
	if event.is_action_pressed("attack") and can_attack:
		attacking = true 
		player_attack()
		start_attack_cooldown()


func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	weapon_slot.rotation = direction.angle()
	
	input_vector = Vector2.ZERO
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
	update_animation()
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

func start_attack_cooldown():
	can_attack = false
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
	print("Attack ready again")


func player_attack() ->void:
	print("attack")

	anim_sprite2.play("empty")
	anim_attack.visible = true
	anim_attack.play("main")
	weapon.disable_mode = false
	
	await get_tree().create_timer(0.5).timeout
	weapon.disable_mode = true
	anim_attack.play("nll")
	weapon.visible = false
	anim_attack.visible = false
	anim_sprite2.play("down")
 
func update_animation():
	
	if input_vector == Vector2.ZERO:
		anim_sprite2.flip_h = false
		anim_sprite.play("idle")
		if not attacking:
			anim_sprite2.play("down")
		anim_sprite.speed_scale=1.35
		anim_sprite2.speed_scale=1.35
	else:
		anim_sprite.speed_scale=2.2
		anim_sprite2.speed_scale=2.2
		if abs(input_vector.x) > abs(input_vector.y):
			
			if input_vector.x > 0:
				anim_sprite2.flip_h = false
				anim_sprite.play("right")
				if not attacking:
					anim_sprite2.play("down")
			else:
				anim_sprite.play("left")
				if not attacking:
					anim_sprite2.play("down")
				anim_sprite2.flip_h = true
		else:
			if input_vector.y > 0:
				anim_sprite2.flip_h = false
				anim_sprite.play("down")
				if not attacking:
					anim_sprite2.play("down")
			else:
				anim_sprite.play("up")
				anim_sprite2.flip_h = true
				if not attacking:
					anim_sprite2.play("down")

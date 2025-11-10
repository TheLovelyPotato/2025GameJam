extends CharacterBody2D

@onready var nav_agent = $NavigationAgent2D
@onready var anim = $AnimatedSprite2D

@export var speed := 100.0
@export var roam_radius := 300.0
@export var wait_time := 1.0  # seconds to pause at each point

var target_position: Vector2
var waiting: bool = false

func _ready():
	anim.play("default")
	nav_agent.max_speed = speed
	pick_new_target()

func _physics_process(delta):
	if waiting:
		return

	# Move toward target
	var next_point = nav_agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()
	velocity = direction * speed
	move_and_slide()

	# Check if reached target
	if global_position.distance_to(target_position) < 5:
		waiting = true
		velocity = Vector2.ZERO
		move_and_slide()
		# Wait for a bit, then pick new target
		await get_tree().create_timer(wait_time)
		waiting = false
		pick_new_target()

func pick_new_target():
	# Pick a random point within roam_radius
	var angle = randf() * TAU
	var distance = randf() * roam_radius
	target_position = global_position + Vector2(cos(angle), sin(angle)) * distance
	nav_agent.target_position = target_position

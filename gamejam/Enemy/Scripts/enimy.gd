extends CharacterBody2D

@onready var bleh = $AnimatedSprite2D
@onready var nav_agent = $NavigationAgent2D
@onready var player = $"../Player"

@export var speed := 150.0
@export var damage := 10
@export var bounce_force := 300.0

func _ready():
	# Configure navigation agent
	nav_agent.path_desired_distance = 5.0
	nav_agent.target_desired_distance = 5.0
	nav_agent.max_speed = speed

	# Connect body_entered signal if this node has an Area2D child
	if has_node("Area2D"):
		$Area2D.body_entered.connect(_on_body_entered)

func _physics_process(delta):
	bleh.play("default")

	if player:
		nav_agent.target_position = player.global_position
		if nav_agent.is_navigation_finished():
			return

		var next_path_point = nav_agent.get_next_path_position()
		var direction = (next_path_point - global_position).normalized()

		velocity = direction * speed
		move_and_slide()

func _on_body_entered(body: Node) -> void:
	if body.has_meta("health"):
		# Damage the player’s health meta
		var current_health = body.get_meta("health")
		current_health -= damage
		body.set_meta("health", current_health)
		print("Player health:", current_health)

		# Bounce this enemy away from the player
		var direction = (global_position - body.global_position).normalized()
		velocity = direction * bounce_force
		move_and_slide()

	# If *this* enemy has health and dies
	if has_meta("health"):
		var h = get_meta("health")
		if h <= 0:
			queue_free()

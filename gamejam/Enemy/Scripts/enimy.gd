extends CharacterBody2D

@onready var bleh = $AnimatedSprite2D
@onready var path = $NavigationAgent2D

func _physics_process(_delta):
	bleh.play("default")
	

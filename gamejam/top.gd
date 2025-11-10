extends Node2D
@onready var im = $AnimatedSprite2D

func _ready() -> void:
	im.play("default")

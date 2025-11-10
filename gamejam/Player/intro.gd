extends AnimatedSprite2D
@onready var th = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	th.play("default")
	await get_tree().create_timer(60).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

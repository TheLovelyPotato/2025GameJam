extends Area2D

@export var damage := 10.0

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	var player = $"../Player"
	player.player_damage(damage)

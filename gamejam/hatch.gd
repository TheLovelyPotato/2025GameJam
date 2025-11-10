extends Area2D

var player_in_range := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = true
		print("player is in ranged")


func _on_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		player_in_range = false
		print("Player left interaction area")

func _process(delta: float) -> void:
	if player_in_range and Input.is_action_just_pressed("use"):
		interaction()

func interaction() -> void:
	get_tree().change_scene_to_file("res://Player/train.tscn")

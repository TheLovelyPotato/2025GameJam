extends Node2D

var player_in_range := false

func _ready() -> void:
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

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
	print("Interaction triggered!")
	var slot = $"../Player/WeaponSlot"
	var weapon_scene = load("res://Weapon/sword.tscn")
	var weapon_instance = weapon_scene.instantiate()

	for child in slot.get_children():
		child.queue_free()
	slot.add_child(weapon_instance)

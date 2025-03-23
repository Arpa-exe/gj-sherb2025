extends Area2D

@onready var player_test: CharacterBody2D = %PlayerTest

func _on_body_entered(body: Node2D) -> void:
	if body == player_test:
		player_test.die()

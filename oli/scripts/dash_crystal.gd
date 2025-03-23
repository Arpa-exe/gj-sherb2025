extends Area2D

@onready var player_test: CharacterBody2D = %PlayerTest

func _on_body_entered(body: Node2D) -> void:
	$AnimatedSprite2D.play("disappear")
	$CollisionShape2D.queue_free()
	pick_up()

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.get_frame() == 12:
		queue_free()

func pick_up():
	player_test.catch_dash_crystal()	
	$AudioStreamPlayer2D.play()

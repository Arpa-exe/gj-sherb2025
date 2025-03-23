extends Area2D

const FOLLOW_SPEED = 4.0

var player
var following = false
var first = false
var offset = 10

func _process(delta):
	if following and player:
		var anim = player.get_node("AnimatedSprite2D")
		if anim != null:
			if anim.flip_h:
				position = position.lerp(player.position + Vector2(offset, 0), delta * FOLLOW_SPEED)
			else:
				position = position.lerp(player.position - Vector2(offset, 0), delta * FOLLOW_SPEED)
		else:
			position = position.lerp(player.position, delta * FOLLOW_SPEED)
		

func _on_body_entered(body: Node2D) -> void:
	player = body
	following = true
	if not first:
		$AudioStreamPlayer2D.play()
		Global.collectibleCount += 1
		first = true
		offset *= Global.collectibleCount

extends AnimatedSprite2D

@onready var button: AnimatedSprite2D = $"."

var can_press = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_press:
		button.play("pressed")

func _on_area_2d_body_entered(body: Node2D) -> void:
	can_press = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	can_press = false

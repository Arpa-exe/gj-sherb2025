extends AnimatedSprite2D

@onready var button: AnimatedSprite2D = $"."
@onready var color_rect: ColorRect = $ColorRect

var can_press = false
var pressed = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_press:
		button.play("pressed")
		pressed = true
	if pressed:
		color_rect.size = get_viewport_rect().size
		color_rect.position = Vector2.ZERO - Vector2(color_rect.size.x/2, color_rect.size.y/2)
		color_rect.color = color_rect.color.lerp(Color.BLACK, 0.1)

func _on_area_2d_body_entered(body: Node2D) -> void:
	can_press = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	can_press = false

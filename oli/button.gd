extends Area2D

@onready var color_rect: ColorRect = $ColorRect
@onready var player_test: CharacterBody2D = %PlayerTest

var can_press = false
var pressed = false
var timer = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and can_press:
		if Global.currentLevel == '1' and Global.collectibleCount == 3:
			pressed = true
		if Global.currentLevel == '2' and Global.collectibleCount == 1:
			pressed = true
		if Global.currentLevel == '3' and Global.collectibleCount == 1:
			pressed = true
			player_test.ending()
	if pressed:
		color_rect.size = get_viewport_rect().size
		color_rect.position = Vector2.ZERO - Vector2(color_rect.size.x/2, color_rect.size.y/2)
		color_rect.color = color_rect.color.lerp(Color.BLACK, 0.01)
		timer += 1
		if timer > 50:
			if Global.currentLevel == "1": # changed level 1 to 2 
				get_tree().change_scene_to_file(Global.level2Scene) # changed level 2 to 1
			elif Global.currentLevel == "2": # changed level 2 to 1
				get_tree().change_scene_to_file(Global.level3Scene)

func _on_body_entered(body: Node2D) -> void:
	can_press = true


func _on_body_exited(body: Node2D) -> void:
	can_press = false

extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var nextLabel = $CanvasLayer/HBoxContainer/HBoxContainer/nextLabel
@onready var crystalUI = $"../CanvasLayer/HBoxContainer/HBoxContainer/TextureRect"
@onready var crystal2UI = $"../CanvasLayer/HBoxContainer/HBoxContainer/TextureRect2"

var is_boing = false

func catch_crystal():
	Global.powers.push_back("boing")
	
func catch_dash_crystal():
	Global.powers.push_back("bing")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("use_item") and len(Global.powers) > 0 and not is_boing:
		is_boing = true
		var next_power = Global.powers.pop_front()
		match next_power:
			"boing":
				spawn_beam()
				var tween = create_tween()
				tween.tween_property(self, "global_position:y", global_position.y - 48, 0.1)
				velocity.y = JUMP_VELOCITY
				is_boing = false
				crystalUI.visible = false
			"bing":
				var direction := Input.get_axis("move_left", "move_right")
				if direction == 0:
					Global.powers.push_front("bing")
					is_boing = false
				else:
					spawn_dash(direction)
					var tween = create_tween()
					tween.tween_property(self, "global_position:x", global_position.x + 80 * direction, 0.2)
					velocity.y = JUMP_VELOCITY / 2
					is_boing = false
					crystal2UI.visible = false
			_:
				pass
		
	# Movement
	var direction := Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true
	
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("IdleRight")
		else:
			animated_sprite_2d.play("Run")
	else:
		animated_sprite_2d.play("Jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func spawn_beam():
	var beam = preload("res://oli/vertical_beam.tscn").instantiate()
	get_parent().add_child(beam)
	beam.global_position = global_position - Vector2(0, 20)
	
func spawn_dash(direction):
	var dash = preload("res://oli/light_dash.tscn").instantiate()
	get_parent().add_child(dash)
	dash.global_position = global_position - Vector2(40, 0)

func removePowerFromUI():
	pass

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	get_tree().change_scene_to_file("res://emma/gameOver.tscn")

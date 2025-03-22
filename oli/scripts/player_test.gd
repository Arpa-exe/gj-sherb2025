extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var nextLabel = $CanvasLayer/HBoxContainer/HBoxContainer/nextLabel
@onready var crystalUI = $"../CanvasLayer/HBoxContainer/HBoxContainer/TextureRect"
@onready var crystal2UI = $"../CanvasLayer/HBoxContainer/HBoxContainer/TextureRect2"

@onready var missingLabel = $"../CanvasLayer/HBoxContainer/missingContainer/Label"
@onready var missingCrystalUI = $"../CanvasLayer/HBoxContainer/missingContainer/TextureRect"
@onready var missingCrystal2UI = $"../CanvasLayer/HBoxContainer/missingContainer/TextureRect2"

var is_boing = false
var alive = true

func catch_crystal():
	Global.powers.push_back("boing")
	missingCrystalUI.visible = false
	
func catch_dash_crystal():
	Global.powers.push_back("bing")
	missingCrystal2UI.visible = false

func _physics_process(delta: float) -> void:
	if alive:
		if len(Global.collectibleLeft) == 0:
			missingLabel.visible = false
		else:
			missingLabel.visible = true
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

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	die()


func _on_hitbox_area_entered(area: Area2D) -> void:
	print("player hitbox ", area.get_parent().get_parent().name)
	print("area: ", area)
	if (area.get_parent().get_parent().name == "Sign"):
		if Global.currentLevel == "1": # changed level 1 to 2 
			get_tree().change_scene_to_file(Global.level2Scene) # changed level 2 to 1
		elif Global.currentLevel == "2": # changed level 2 to 1
			get_tree().change_scene_to_file(Global.level3Scene)
		elif Global.currentLevel == "3":
			get_tree().change_scene_to_file(Global.endScene)
	elif area.get_parent().get_parent().name == "spike":
		die()
	pass # Replace with function body.

func die():
	alive = false
	animated_sprite_2d.play("die")


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite_2d.get_animation() == "die":
		get_tree().change_scene_to_file(Global.gameOverScene)


func _on_stomp_area_area_entered(area: Area2D) -> void:
	print("areaaa: ", area.get_parent().name)
	if (area.get_parent().name == "enemySlime"):
		area.get_parent().die()
